From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: xfstests tests/ext4/304
Date: Tue, 20 Jan 2015 10:59:43 +0800
Message-ID: <54BDC49F.6040305@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	<fstests@vger.kernel.org>, <fio@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10888 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751597AbbATDEV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Jan 2015 22:04:21 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Does anyone see xfstests tests/ext4/304 failed in your test environment. I run
this case in v3.19-rc5, it always fails to me... I tried to figure out the true
reason, below is my analysis, I think either fio tool, or this 304 case has some
bugs, please have a check. But sorry firstly, I don't have much time to check fio
code that deep, I just checked how fio/engines/e4defrag.c is implemented, so you
can take my analysis as a bug report, thanks in advance :)

When I run tests/ext4/304, this corresponding fio config file is:
########################################################
# Common e4defrag regression tests
[global]
ioengine=ioe_e4defrag
iodepth=1
directory=/mnt/xfstests/scratch
filesize=3565158400
size=999G
buffered=0
fadvise_hint=0

# Test4
# Stress test defragmentation engine
# Several threads perform defragmentation at random position
# use inplace=1 will allocate and free blocks inside defrag event
# which highly increase defragmentation
[defrag-fuzzer]
ioengine=e4defrag
iodepth=1
bs=8k
donorname=test4.def
filename=test4
inplace=1
rw=randwrite
numjobs=4*1
runtime=30*1
time_based

[aio-dio-verifier]
ioengine=libaio
iodepth=128
iomem_align=4k
numjobs=1
verify=crc32c-intel
verify_fatal=1
verify_dump=1
verify_backlog=1024
verify_async=1
verifysort=1
direct=1
bs=64k
rw=write
filename=test4
runtime=30*1
time_based
########################################################
You can "fio config-file" directly in an ext4 file system. 

When I run this case in my v3.19-rc5 virtual machine, I always got a EINVAL error.
This EINVAL error is returned from mext_check_arguments() in fs/ext4/move_extent.c:

	if ((!orig_inode->i_size) || (!donor_inode->i_size)) {
		printk(KERN_ERR "ext4 move extent: File size is 0 byte\n");
		return -EINVAL;
	}

I think there is nothing wrong with ext4 kernel side, so could anyone help to confirm
whether e4defrag engine(inplace=1 mode) in fio tool or this 304 case is not implemented correctly.
See my analysis below: I have removed some irrelevant codes.

in fio/engines/e4defrag.c. We check inplace=1 mode.
###############################################
static int fio_e4defrag_init(struct thread_data *td)
{
	int r, len = 0;
	struct e4defrag_options *o = td->eo;
	struct e4defrag_data *ed;
	struct stat stub;
	char donor_name[PATH_MAX];

	....

	if (!o->inplace) {
		long long len = td->o.file_size_high - td->o.start_offset;
		r = fallocate(ed->donor_fd, 0, td->o.start_offset, len);
		if (r)
			goto err;
	}
	...
}
...


static int fio_e4defrag_queue(struct thread_data *td, struct io_u *io_u)
{

	int ret;
	unsigned long long len;
	struct move_extent me;
	
	....

	if (o->inplace) {
		ret = fallocate(ed->donor_fd, 0, io_u->offset, io_u->xfer_buflen);  //race point
		if (ret)
			goto out;
	}
	
	...

	ret = ioctl(f->fd, EXT4_IOC_MOVE_EXT, &me);  //race point
	len = me.moved_len * ed->bsz;

	...

	if (o->inplace)
		ret = ftruncate(ed->donor_fd, 0);  // race point

	...
}
###############################################

In this case, we fork 4 process to do defragment work. Assume that 3 process have fallocated some
physical blocks, but before they started to do ioctl(EXT4_IOC_MOVE_EXT), another process has finished
its job, and did a ftruncate operation, now donor file's size is 0, then the first 3 process will fail
(because donor file's size is 0, being truncated). I think it's the reason that tests/ext4/304 fails.

To be honest, I do not know whether there have been some fio internal mechanisms to serialize these operations,
such as:
	/* for inplace=1 mode*/
	lock();
	fallocate(...);
	ioctl(EXT4_IOC_MOVE_EXT);
	ftruncate(fd, 0);
	unlock();

If there are already some mechanisms to protect these races, it'll mean that there are no much meaning to
set numjobs greater than 1, because these operation have already been serialized. If there are no such
mechanisms,  I think the above scenario will surely be triggered.

I don't know whether I have missed something, but this test 304 really failed to me. 

Regards,
Xiaoguang Wang
