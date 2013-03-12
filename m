From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: torrent hash failures since 3.9.0-rc1
Date: Tue, 12 Mar 2013 07:16:24 +0100
Message-ID: <20130312061624.GA436@x4>
References: <20130311191753.GA439@x4>
 <20130311194159.GB3579@redhat.com>
 <20130311201334.GA444@x4>
 <20130311203738.GB15478@thunk.org>
 <20130311204625.GA433@x4>
 <20130311211833.GC15478@thunk.org>
 <20130311213837.GA438@x4>
 <20130311231227.GA319@x4>
 <20130312030057.GA6142@gmail.com>
 <20130312033054.GB18595@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Dave Jones <davej@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130312033054.GB18595@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2013.03.11 at 23:30 -0400, Theodore Ts'o wrote:
> On Tue, Mar 12, 2013 at 11:00:58AM +0800, Zheng Liu wrote:
> > 
> > Thanks for reporting this problem.  My deepest apologies.
> > 
> > As Ted suggested, could you please try to use ext4 git tree?  I want to
> > make sure whether this bug has been fixed by my lastest patch series or
> > not.
> 
> It's definitely worth a try to compile the master branch of the ext4
> tree and see if it reproduces or not.

I cannot reproduce the issue on top of "ext4.git dev", so fortunately
the problem seems to be already fixed there.
Thanks.

Do you guys have a hunch which commit is the actual fix? 
(Maybe I will "bisect" it later today.)

-- 
Markus
