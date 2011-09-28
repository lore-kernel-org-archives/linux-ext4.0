From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] Re: [patch 1/1] ext4-fix-dirty-extent-when-origin-leaf-extent-reac.patch
Date: Wed, 28 Sep 2011 11:41:11 -0700
Message-ID: <4E836A47.80107@goop.org>
References: <BLU157-W499E698F650F554E645F9DDA1C0@phx.gbl> <20110906145347.GA4133@dumpdata.com> <BLU157-W4106FA4CF4EBA78C63FDA0DA1C0@phx.gbl> <4E666C86.5090707@goop.org> <BLU157-W323C330706CB8D7E976BC3DA1F0@phx.gbl> <BLU157-W7DABA5FE01C50C29B1A64DA060@phx.gbl> <BLU157-W25EB1EAC24CC11FA14859ADAF20@phx.gbl> <20110926142808.GG4102@phenom.oracle.com> <20110927193523.GB3309@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	MaoXiaoyun <tinnycloud@hotmail.com>, linux-ext4@vger.kernel.org,
	jack@suse.cz, xen devel <xen-devel@lists.xensource.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from claw.goop.org ([74.207.240.146]:38771 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab1I1SlN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Sep 2011 14:41:13 -0400
In-Reply-To: <20110927193523.GB3309@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/27/2011 12:35 PM, Ted Ts'o wrote:
> On Mon, Sep 26, 2011 at 10:28:08AM -0400, Konrad Rzeszutek Wilk wrote:
>>>  
>>>    Attached is the fix, verified in our env. 
>> So.. you are asking for this upstream git commit to be back-ported
>> to 2.6.32, right?
> I'm curious --- is there a good reason why Xen users are using an
> upstream 2.6.32 kernel?  If they are using a distro kernel, fine, but
> then the distro kernel should be providing the support.  But at this
> point, 2.6.32 is so positively *ancient* that, I'm personally not
> interesting in providing free, unpaid distro support for users who
> aren't willing to either (a) pay $$$ and get a supported distro
> kernel, or (b) use a much more modern kernel.  At this point, Guest
> and Host Xen support is available in 3.0 kernels, so there's really no
> excuse, right?

The 2.6.32.x-based kernel has been the preferred "stable" kernel for Xen
users for a while, and it is still considered to be more stable and
functional than what's upstream (obviously we're trying to fix that). 
Also, because many current distros don't support Xen dom0, it has been
an ad-hoc distro kernel.

Since kernel.org 2.6.32 is still considered to be a maintained
long-term-stable kernel, I keep the xen.git version up-to-date with
stable-2.6.32 bugfixes and occasional separate Xen-specific fixes.  But
I'd really prefer to avoid having any non-Xen private changes in that
tree, in favour of getting everything from upstream stable.

Do you not consider it worth continuing support of the 2.6.32 stable
tree with respect to ext4?

    J
