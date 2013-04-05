From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Subject: Re: [PATCH] ext4: fixup 64-bit divides in linux-3.0 stable backport
 of upstream fix
Date: Sat, 6 Apr 2013 01:31:29 +0200
Message-ID: <1365204363@msgid.manchmal.in-ulm.de>
References: <1365202463-25872-1-git-send-email-toddpoynor@google.com>
 <20130405230107.GA8412@kroah.com>
 <CAAW3YpbM7Vk_=qXv2NCgRsCkashsTpYC_6osA_udm2oDsiz5qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	Lingzhu Xiang <lxiang@redhat.com>, linux-ext4@vger.kernel.org
To: Todd Poynor <toddpoynor@google.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAW3YpbM7Vk_=qXv2NCgRsCkashsTpYC_6osA_udm2oDsiz5qA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Todd Poynor wrote...

> On Fri, Apr 5, 2013 at 4:01 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Apr 05, 2013 at 03:54:23PM -0700, Todd Poynor wrote:
> > > Replace C division operators with div64_u64 for divides introduced in:
> > > commit 503f4bdcc078e7abee273a85ce322de81b18a224
> > > ext4: use atomic64_t for the per-flexbg free_clusters count
> > >
> > > Specific to the linux-3.0 backport of the upstream patch.
> >
> > Why is this specific?  Why is this working differently in 3.0 from 3.4
> > and newer?
> 
> Looks like 3.1 doesn't have this patch.

Just comparing the "ext4: use atomic64_t for the per-flexbg
free_clusters count" patches for 3.0 and 3.4, your fix and git: The
build errors in 3.0.72 your patch fixes originate in find_group_flex
which was removed in v3.1-rc3-44-g4113c4c, hence only 3.0 was
affected.

    Christoph
