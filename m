From: Chris Lee <cslee-list@cybericom.co.uk>
Subject: Shorten the backup process?
Date: Sat, 09 Oct 2010 21:35:32 +0100
Message-ID: <4CB0D214.1070301@cybericom.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mk-outboundfilter-5-a-2.mail.uk.tiscali.com ([212.74.114.4]:47659
	"EHLO mk-outboundfilter-5-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757171Ab0JIUpA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Oct 2010 16:45:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,
I hope this to bee food for thought as I am not able to code such a thing nor am 
I in need of such a thing but it seemed like a good idea when it struck me, so;
When an filesystem is snap shotted it is a function of the  running filesystem 
to provide the data in that snapshot. (or is that lvms doing?)
Most users who use snapshots for backup are going to mount the snap shot and 
then tar it up.
Would it be a good idea to provide a virtual file through something like the 
sysfs that is a tar representation of the snapshot so that a backup can just 
copy the tar file off as needed?

Thanks for reading,

Regards,
Chris.


