From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 1/6] xfstest: add fio git submodule
Date: Mon, 24 Sep 2012 08:23:04 -0400
Message-ID: <CAGpXXZ+LGZcoztAcEND46ndhmGbKHjVmykAU4d11Jsf7B_L53Q@mail.gmail.com>
References: <1348428276-13161-1-git-send-email-dmonakhov@openvz.org> <505FD0A9.3090601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	hch@lst.de, xfs@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <505FD0A9.3090601@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Sep 23, 2012 at 11:16 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> (I package fio for Fedora, is it not commonly available on other
> distros?)

opensuse has it in the benchmarking repo, but not in the main release
repos.  If it is getting regular updates and users will want to have
the latest version, it makes sense for opensuse to leave it that way.
This discussion may change that.

As of a year ago, xfstests dependencies could all be met from the main
repos.  (see howto http://en.opensuse.org/SDB:XFStests)

I believe a basic set of xfstests is run as part of the QA process for
every factory build (factory is similar to rawhide).  At least it was
during 12.1 pre-release testing a year ago.
http://openqa.opensuse.org/results/

Not a huge deal, but having xfstests tests which depend on fio would
either mean opensuse dropping those tests that depend on fio from its
routine QA testing, or it would mean adding fio to the main distro.

How far into xfstests is fio likely to integrate?  If it is to become
a core tool and it is not going to be provided by xfstests itself, I
can try to submit fio to factory.  It will just have to kept new
enough to satisfy xfstests version requirements.

I do hope that if the distro has to provide a fio package, then
xfstests only depend on the version, not the git check-in.

Greg
