From: Felipe Franciosi <felipe@paradoxo.org>
Subject: Committing changes to an ext3_inode structure
Date: Tue, 19 Oct 2010 16:23:48 +0100
Message-ID: <CB87EF37-0485-4A48-B401-EA594BE47B29@paradoxo.org>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33144 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab0JSPYA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Oct 2010 11:24:00 -0400
Received: by wyb28 with SMTP id 28so2605162wyb.19
        for <linux-ext4@vger.kernel.org>; Tue, 19 Oct 2010 08:23:58 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear all,

I am experimenting on a 2.6.20.3-ubuntu1 kernel to prototype and  
evaluate different methods for migrating datablocks for a given inode  
on the fly.

I have created an ioctl call that implements some verifications and  
invokes a function I wrote in balloc.c for such migration.

Upon receiving a struct inode*, I retrieve the corresponding iloc  
using the ext3_get_inode_iloc() function and then the struct  
ext3_inode* using the ext3_raw_inode() on the iloc. I have confirmed  
the pointer is correct by printing several ext3_inode relevant fields.

After making my modifications to the i_block array, I am finding it  
impossible to commit these changes to the inode itself.

I have tried different things such as marking the iloc.bh buffer_head  
as dirty and submitting it for writing, marking the page as dirty,  
etc, but I think I'm missing something more fundamental. Most of my  
attempts were planned according to what I've seen inside similar code  
of buffer_head manipulation.

Can anyone shed some light on what I'm missing?

Regards,
Felipe
