From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC] jbd2: reduce the number of writes when commiting a transacation
Date: Fri, 20 Apr 2012 19:06:27 +0800
Message-ID: <20120420110627.GA30373@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi list,

In this thread[1], I found a defect in jbd2 because it needs two wrties
to finish a transacation because it writes journal header and data to
disk and it will write commit to disk after above writes are done.
AFAIK, in jbd2, it will call submit_bh twice at least to write the data
because journal header, data and commit are stored in different
buffer_heads.  If we don't call them separately, these calls might be
out of order.  Obviously, it must ensure that journal header and data are
written before commit.  But this brings a huge overhead in this
benchmark[2].  So, IMHO, if we could use *bio* to store these data
rather than buffer_head, we could avoid this overhead because we can
call submit_bio only once to write all of data, which contains journal
header, data and commit.  Here is an issue that I don't determine.  If
we use submit_bio to write journal data, it will make all of data with
WRITE_FLUSH_FUA flag.  But now there is only commit data with this flag.
I am not sure whether or not it brings some other unpridictable
problems. :(

Please feel free to comment this RFC.  Thank you.

1. http://www.spinics.net/lists/linux-ext4/msg31637.html
2. benchmark: time for((i=0;i<2000;i++)); do \
		dd if=/dev/zero of=/mnt/sda1/testfile conv=notrunc bs=4k \
		count=1 seek=`expr $i \* 16` oflag=sync,direct 2>/dev/null; \
		done

Regards,
Zheng
