From: Kavita Kulkarni <Kavita_Kulkarni@qualexsystems.com>
Subject: issue of ext3_file_write function & remote shares
Date: Fri, 13 Feb 2009 18:16:24 +0530
Message-ID: <1234529184.3927.3.camel@Q0405CPU53.qualexsystems.com>
Reply-To: Kavita_Kulkarni@qualexsystems.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.qualexsystems.com ([203.123.162.235]:47691 "EHLO
	earth.qualexsystems.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751599AbZBMMqc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Feb 2009 07:46:32 -0500
Received: from [192.168.7.77] ([192.168.7.77])
	by earth.qualexsystems.com (8.13.1/8.13.1) with ESMTP id n1DCkO2O014993
	for <linux-ext4@vger.kernel.org>; Fri, 13 Feb 2009 18:16:25 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The "ext3_file_write" function in the file
"/usr/src/linux-source/fs/ext3/file.c" is called whenever a file is
accessed/modified.
Now, i have inserted a simple printk and some more code of mine in it
immediately after declaration/initialization of variables. When a local
file is accessed, this printk as well the other code is executed
successfully. But when i export a share and mount it remotely and do
some operations like writing to a file in it, neither my code nor even
the simple printk(which is without any conditions) is executed.
And after this takes place, it doesnt even work locally.
I'm unable to find any solution.
Any help will be welcome.
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

