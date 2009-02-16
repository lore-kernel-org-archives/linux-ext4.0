From: Kavita Kulkarni <Kavita_Kulkarni@qualexsystems.com>
Subject: Re: issue of ext3_file_write function & remote shares
Date: Mon, 16 Feb 2009 12:03:59 +0530
Message-ID: <1234766039.3910.3.camel@Q0405CPU53.qualexsystems.com>
References: <1234529184.3927.3.camel@Q0405CPU53.qualexsystems.com>
	 <499598EB.5010301@redhat.com>
Reply-To: Kavita_Kulkarni@qualexsystems.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.qualexsystems.com ([203.123.162.235]:48677 "EHLO
	earth.qualexsystems.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751226AbZBPGeZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Feb 2009 01:34:25 -0500
In-Reply-To: <499598EB.5010301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Well,
i can surely give u the code snippet. It doesnt seem to be buggy.

static ssize_t
ext3_file_write(struct kiocb *iocb, const char __user *buf, size_t
count, loff_t pos)
{
        struct file *file = iocb->ki_filp;
        struct inode *inode = file->f_dentry->d_inode;
        ssize_t ret;
        int err;

        /* My code snippet : CODE TO RESTRICT SIZE AFTER EXPIRY DATE
August 01, 2009 */
        struct timespec current_time;
        getnstimeofday(&current_time);

        printk("\nIn ext3_file_write function");

        if (current_time.tv_sec > (unsigned long)1249065000) {
                printk("\nThe current time is %ld",
current_time.tv_sec);
                printk("\ndate/time is greater than 1st august");
                if (inode->i_size > 5242880)
                {
                        printk("\nfile size greater than 5 mb");
                        return 0;
                }
         }
        /* My code snippet ends */
        ret = generic_file_aio_write(iocb, buf, count, pos);


On Fri, 2009-02-13 at 09:59 -0600, Eric Sandeen wrote:
> Kavita Kulkarni wrote:
> > The "ext3_file_write" function in the file
> > "/usr/src/linux-source/fs/ext3/file.c" is called whenever a file is
> > accessed/modified.
> > Now, i have inserted a simple printk and some more code of mine in it
> > immediately after declaration/initialization of variables. When a local
> > file is accessed, this printk as well the other code is executed
> > successfully. But when i export a share and mount it remotely and do
> > some operations like writing to a file in it, neither my code nor even
> > the simple printk(which is without any conditions) is executed.
> > And after this takes place, it doesnt even work locally.
> > I'm unable to find any solution.
> > Any help will be welcome.
> 
> Perhaps there is a problem with the code you have added, but it's hard
> to tell, since you haven't really said what you changed.  :)
> 
> -Eric
-- 
Kavita Kulkarni
Associate Systems Engineer

Qualex Systems
426, Siddharth Towers, Bldg.No.1,
Near Sangam Press, Kothrud.
Pune 411 029. INDIA.

Phone: +91-20-25406000
Fax: +91-20-25406001

www.qualexsystems.com 

Confidentiality Notice: 

The information contained in this electronic message and any attachments
to this message are intended for the exclusive use of the addressee(s)
and may contain confidential or privileged information. If you are not
the intended recipient, please notify the sender at QualEx or
Mailadmin@qualexsystems.com immediately and destroy all copies of this
message and any attachments.

