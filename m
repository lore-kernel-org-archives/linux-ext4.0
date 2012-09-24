From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/6] xfstest: add fio git submodule
Date: Mon, 24 Sep 2012 16:41:42 +0400
Message-ID: <87r4pr1tkp.fsf@openvz.org>
References: <1348428276-13161-1-git-send-email-dmonakhov@openvz.org> <505FD0A9.3090601@redhat.com> <CAGpXXZ+LGZcoztAcEND46ndhmGbKHjVmykAU4d11Jsf7B_L53Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	hch@lst.de, xfs@oss.sgi.com
To: Greg Freemyer <greg.freemyer@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41257 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab2IXMlo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Sep 2012 08:41:44 -0400
In-Reply-To: <CAGpXXZ+LGZcoztAcEND46ndhmGbKHjVmykAU4d11Jsf7B_L53Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 24 Sep 2012 08:23:04 -0400, Greg Freemyer <greg.freemyer@gmail.com> wrote:
> On Sun, Sep 23, 2012 at 11:16 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> > (I package fio for Fedora, is it not commonly available on other
> > distros?)
> 
> opensuse has it in the benchmarking repo, but not in the main release
> repos.  If it is getting regular updates and users will want to have
> the latest version, it makes sense for opensuse to leave it that way.
> This discussion may change that.
> 
> As of a year ago, xfstests dependencies could all be met from the main
> repos.  (see howto http://en.opensuse.org/SDB:XFStests)
> 
> I believe a basic set of xfstests is run as part of the QA process for
> every factory build (factory is similar to rawhide).  At least it was
> during 12.1 pre-release testing a year ago.
> http://openqa.opensuse.org/results/
> 
> Not a huge deal, but having xfstests tests which depend on fio would
> either mean opensuse dropping those tests that depend on fio from its
> routine QA testing, or it would mean adding fio to the main distro.
> 
> How far into xfstests is fio likely to integrate?  If it is to become
> a core tool and it is not going to be provided by xfstests itself, I
> can try to submit fio to factory.  It will just have to kept new
> enough to satisfy xfstests version requirements.
As far as i can say fio potentially can replace most of hardcoded 
regression binaries.
> 
> I do hope that if the distro has to provide a fio package, then
> xfstests only depend on the version, not the git check-in.

> 
> Greg
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
