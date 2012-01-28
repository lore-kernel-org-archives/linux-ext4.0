From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: New warning: Unable to get device geometry for [filename]
Date: Fri, 27 Jan 2012 21:57:27 -0600
Message-ID: <4F237227.2000208@redhat.com>
References: <20120127225346.GA7449@amd.home.annexia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666Ab2A1D52 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Jan 2012 22:57:28 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0S3vSu5026586
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 27 Jan 2012 22:57:28 -0500
In-Reply-To: <20120127225346.GA7449@amd.home.annexia.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/27/12 4:53 PM, Richard W.M. Jones wrote:
> 
> I've just noticed that with the latest e2fsprogs, kernel 3.3.0 and
> blkid (util-linux 2.20.1), I see this spurious warning when using
> mke2fs on a file:
> 
>   $ truncate -s 4G test1.img
>   $ mke2fs -t ext2 -q -F test1.img 
>   warning: Unable to get device geometry for test1.img
> 
> Oddly this *doesn't* happen except on the very bleeding edge latest
> versions of everything.  I've not (yet) worked out exactly what
> component has to be upgraded to see it ...

Taking a quick look, I don't _think_ anything above blkid changed
in e2fsprogs lately, but keep us posted.

Does mkfs.xfs do any differently?

thanks,
-Eric
 
> Rich.
> 

