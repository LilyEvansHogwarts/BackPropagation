import tensorflow as tf

'''
#case2
input = tf.Variable(tf.random_normal([1,3,3,5]))
filter = tf.Variable(tf.random_normal([1,1,5,1]))
op2 = tf.nn.conv2d(input, filter, strides = [1,1,1,1], padding = 'VALID')


#case3
input = tf.Variable(tf.random_normal([1,3,3,5]))
filter = tf.Variable(tf.random_normal([3,3,5,1]))
op3 = tf.nn.conv2d(input, filter, strides = [1,1,1,1], padding = 'VALID')

#case4
input = tf.Variable(tf.random_normal([1,5,5,5]))
filter = tf.Variable(tf.random_normal([3,3,5,1]))
op4 = tf.nn.conv2d(input, filter, strides = [1,1,1,1], padding = 'VALID')

#case5
input = tf.Variable(tf.random_normal([1,5,5,5]))
filter = tf.Variable(tf.random_normal([3,3,5,1]))
op5 = tf.nn.conv2d(input, filter, strides = [1,1,1,1], padding = 'SAME')
'''
#case6
input = tf.Variable(tf.random_normal([1,5,5,5]))
filter = tf.Variable(tf.random_normal([3,3,5,7]))
op6 = tf.nn.conv2d(input, filter, strides = [1,1,1,1], padding = 'SAME')
'''
#case7
input = tf.Variable(tf.random_normal([1,5,5,5]))
filter = tf.Variable(tf.random_normal([3,3,5,7]))
op7 = tf.nn.conv2d(input, filter, strides = [1,2,2,1], padding = 'SAME')

#case8
input = tf.Variable(tf.random_normal([10,5,5,5]))
filter = tf.Variable(tf.random_normal([3,3,5,7]))
op8 = tf.nn.conv2d(input, filter, strides = [1,2,2,1], padding = 'SAME')
'''

init = tf.initialize_all_variables()
with tf.Session() as sess:
	sess.run(init)
	print('case 6')
	print('input')
	print(input)
	print('filter')
	print(filter)
	print(sess.run(op6))
	print(op6.get_shape().as_list())
'''
	print('case 2')
	print(sess.run(op2))
	print('case 3')
	print(sess.run(op3))
	print('case 4')
	print(sess.run(op4))
	print('case 5')
	print(sess.run(op5))
	print('case 6')
	print(sess.run(op6))
	print('case 7')
	print(sess.run(op7))
	print('case 8')
	print(sess.run(op8))
'''
