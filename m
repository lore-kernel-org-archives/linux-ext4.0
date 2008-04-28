From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: Using tgid instead of pid in ext3_find_near()
Date: Tue, 29 Apr 2008 00:37:35 +0530
Message-ID: <ea11fea30804281207u5fe9e96bod992dc2bb2d3fc79@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Kernel Newbies" <kernelnewbies@nl.linux.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:35273 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934218AbYD1THi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Apr 2008 15:07:38 -0400
Received: by ug-out-1314.google.com with SMTP id z38so886165ugc.16
        for <linux-ext4@vger.kernel.org>; Mon, 28 Apr 2008 12:07:36 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

In the function ext*_find_near() we are using pid to have the locality
of the blocks for the files which have same functionality. Shouldn't
we be using "current->tgid" here instead ??

410 static ext3_fsblk_t ext3_find_near(struct inode *inode, Indirect *ind)
 411 {
.........
........
433  colour = (current->pid % 16) *
 434    (EXT3_BLOCKS_PER_GROUP(inode->i_sb) / 16);
........

-- 
Thanks & Regards,
********************************************
Manish Katiyar ( http://mkatiyar.googlepages.com )
3rd Floor, Fair Winds Block
EGL Software Park
Off Intermediate Ring Road
Bangalore 560071, India
***********************************************
