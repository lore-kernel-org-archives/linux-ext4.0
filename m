From: jon ernst <jonernst07@gmail.com>
Subject: Re: xfstests failures in v3.13-rc7
Date: Wed, 8 Jan 2014 04:56:19 +0000
Message-ID: <CAGW2f1Hdv42u=yHoFVhmx72z88gyNUC4MbQQ0UGk8BceNNEbGA@mail.gmail.com>
References: <1389063428.2169.12.camel@ancientdefender.lm.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"matthew@wil.cx" <matthew@wil.cx>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:36040 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbaAHE4V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jan 2014 23:56:21 -0500
Received: by mail-qa0-f48.google.com with SMTP id i13so1425711qae.35
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jan 2014 20:56:19 -0800 (PST)
In-Reply-To: <1389063428.2169.12.camel@ancientdefender.lm.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Vishal,

I am ext4 newbie. Though I could share my experience about test 013 failure.
Make sure you have latest (or 1.42.9) e2fsck installed on your system.

Notice that v1.42.8 will cause 013 fail due to this:
http://comments.gmane.org/gmane.comp.file-systems.ext4/39980

To confirm my guess, you can check your xfstest full log to see if
e2fsck fail or not.


Just my idea. Could be wrong. Please correct me.

Best,
Jon

On Tue, Jan 7, 2014 at 2:57 AM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
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
>
> The output of xfstests for these failures is also attached.
>
> It looks like generic/013 should be resolved by:
> http://thread.gmane.org/gmane.comp.file-systems.ext4/42032
> Are any of the others known failures, especially for brd?
>
> Thanks,
>         -Vishal
>
