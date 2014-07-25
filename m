From: "Dilger, Andreas" <andreas.dilger@intel.com>
Subject: Re: Unable to build e2fsprogs 1.42.11 on RHEL 5
Date: Fri, 25 Jul 2014 21:36:53 +0000
Message-ID: <CFF824ED.B3D18%andreas.dilger@intel.com>
References: <CFF6DF2A.B393D%andreas.dilger@intel.com>
 <20140725143338.GS1865@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60928 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbaGYVgz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2014 17:36:55 -0400
In-Reply-To: <20140725143338.GS1865@thunk.org>
Content-Language: en-US
Content-ID: <B2DF418233CB5943B14798B98AC7C52D@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2014/07/25, 8:33 AM, "Theodore Ts'o" <tytso@mit.edu> wrote:

>On Thu, Jul 24, 2014 at 10:04:53PM +0000, Dilger, Andreas wrote:
>> I'm unable to build the latest e2fsprogs on RHEL 5, since it returns an
>> error running autoconf:
>> 
>>   autoconf
>>   aclocal.m4:3095: error: Autoconf version 2.60 or higher is required
>>   aclocal.m4:3095: the top level
>
>What I try to tell everyone is that the only people who should run
>autoconf are developers.  If you are building on a systems that are
>running older versions of autoconf, such as RHEL or LTS, you should
>simply *not* run autoconf, or autoreconf, or anything else like that.
>If you do, that's something which is explicitly disclaimed.

Unfortunately, because some of our patches add new features and modify
configure.in the autoconf steps run automatically during the build,
even though the patches also modify configure to include the changes
that autoconf generates therein.

Unfortunately, because configure comes before configure.in lexographically,
and the patches are in Git I don't think there is any way for them to
be applied in reverse order like there would be with e.g. patch files
applied using quilt.

>The reason why we have the AC_PREREQ(2.60) is because of the
>AC_PROG_MKDIR_P requirement which you noted.
>
>> It looks like this was added in commit 93613951 "aclocal.m4: update
>> to newer versions of autoconf macros".  Was there a particular
>> reason for that change (there is no explanation given in the commit
>> message)?
>
>It was part of some work to update the autoconf and config.* files to
>support some new platforms, such as ppcle.  (I think there was some
>other platform that Ross Burton at Intel was trying to enable, but I'm
>not sure what it was.)  While I was looking at these files, I noticed
>that the gettext related macros were close to a decade old, and I
>decided it was time to update them.
>
>For RHEL5, it should be safe to revert the change, but the simpler
>thing is to simply lay off trying to regenerate the configure.in file.
>Autoconf doesn't have very good compatibility support, so whenever we
>update autoconf related files, it's possible that future changes will
>require changes to the Makefile.in files.

Reverting the 93613951 commit works for now.  I might end up changing
the RHEL5 .spec file to "touch configure" if they have approximately
the same timestamp (e.g. within 1s) so that autoconf is not run
automatically after a patch is applied to both, or a fresh checkout.

This might also be useful for the upstream e2fsprogs.spec.in file so
that autoconf is not run when there is a new checkout.

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


