From: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: Re: Working in Ext4 FS
Date: Fri, 15 Sep 2006 08:01:49 -0500
Message-ID: <1158325309.12076.17.camel@kleikamp.austin.ibm.com>
References: <59d33ffa0609142311y473aaa78oadc5d695c3dd011a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, udayan.singh@tcs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:57013 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751370AbWIONBv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Sep 2006 09:01:51 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8FD1o3U018266
	for <linux-ext4@vger.kernel.org>; Fri, 15 Sep 2006 09:01:50 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8FD1odE281820
	for <linux-ext4@vger.kernel.org>; Fri, 15 Sep 2006 09:01:50 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8FD1oAr006733
	for <linux-ext4@vger.kernel.org>; Fri, 15 Sep 2006 09:01:50 -0400
To: Udayan Singh <singh.udayan@gmail.com>
In-Reply-To: <59d33ffa0609142311y473aaa78oadc5d695c3dd011a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2006-09-15 at 11:41 +0530, Udayan Singh wrote:
> Hello All,
> 
> I am interested in working on ext4 development. Have worked on linux
> (driver development) as a part of my job. Also had done some internal
> work on ext2fs (more of knowledge building).
> 
> My plan would be to understand the new features that are planned for
> ext4 development. Where can I get this information ?

A wiki page was started, but hasn't been updated in a while:
http://fedoraproject.org/wiki/ext3-devel
It was created before it was decided to branch ext4.  :-)

The archives for this mailing list are probably the most complete
reference.  The gmane archive,
http://news.gmane.org/gmane.comp.file-systems.ext4 , appears incomplete.
This one looks to be in better shape:
http://www.mail-archive.com/linux-ext4@vger.kernel.org/

The set of patches against 2.6.18-rc6 was recently announced to the
mailing list:
http://www.mail-archive.com/linux-ext4@vger.kernel.org/msg00051.html

I'm working on porting them to 2.6.18-rc6-mm2 and cleaning them up a
little bit.  I'm hoping I get that done later today.

> Then start with some minor contribution.
> 
> Would appreciate your suggestions.
> 
> Regards,
> Udayan
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
David Kleikamp
IBM Linux Technology Center

