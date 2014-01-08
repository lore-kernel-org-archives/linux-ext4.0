From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: xfstests failures in v3.13-rc7
Date: Wed, 8 Jan 2014 12:53:09 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1401081248030.2257@localhost.localdomain>
References: <1389063428.2169.12.camel@ancientdefender.lm.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"matthew@wil.cx" <matthew@wil.cx>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205AbaAHLxN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jan 2014 06:53:13 -0500
In-Reply-To: <1389063428.2169.12.camel@ancientdefender.lm.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 7 Jan 2014, Verma, Vishal L wrote:

> Date: Tue, 7 Jan 2014 02:57:13 +0000
> From: "Verma, Vishal L" <vishal.l.verma@intel.com>
> To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
> Cc: "matthew@wil.cx" <matthew@wil.cx>
> Subject: xfstests failures in v3.13-rc7
> 
> Hi,
> 
> I have been running xfstests with ext4 on a ramdisk (brd), and noticed a
> few tests were failing with an inconsistent file system at the end of
> the test.
> 
> The following fail for v3.13-rc7:
> generic/013
> generic/083
> generic/269
> generic/321 (this one is not inconsistent fs, see log)
> generic/322

Hi,

Unfortunately you have not provided *.full logs, but I believe that
at least 013, 083 and 269 failures are caused by bug in e2fsprogs
which was fixed with:

085757fcc22a86168ee6793dfad9a95d88fb09db e2fsck: don't report uninit
extents past EOF invalid

which is present in the lates e2fsprogs release 1.42.9.

Please retest with that.

Thanks!
-Lukas

> 
> The output of xfstests for these failures is also attached.
> 
> It looks like generic/013 should be resolved by:
> http://thread.gmane.org/gmane.comp.file-systems.ext4/42032
> Are any of the others known failures, especially for brd?
> 
> Thanks,
> 	-Vishal
> 
> 
