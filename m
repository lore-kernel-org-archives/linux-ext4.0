From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Mon, 19 Mar 2012 10:09:03 -0700
Message-ID: <1332176943.1983.28.camel@joe2Laptop>
References: <cover.1331856299.git.joe@perches.com>
	 <ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>
	 <20120319040950.GG31682@thunk.org> <1332131137.23125.44.camel@joe2Laptop>
	 <4F6762F1.7050902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jiri Slaby <jirislaby@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F6762F1.7050902@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2012-03-19 at 17:46 +0100, Jiri Slaby wrote:
> On 03/19/2012 05:25 AM, Joe Perches wrote:
> > On Mon, 2012-03-19 at 00:09 -0400, Ted Ts'o wrote:
> >> One evidence that this patch is noise is that it doesn't apply cleanly
> >> just on top of my current patch set that I plan to send to Linus.
> > It's more evident that you don't make
> > public your own internal patch queue
> > quickly enough than anything else.
> Please stop repeating that shit. I already explained you the reasons. A
> couple of weeks ago.

shrug.

I don't quite understand your comment on this
subject as git log -i --grep=slaby fs/ext4
doesn't show your name.

As far as I can tell, your "reasons" as you
explained it is that you just do not like
whitespace or style changes.

Ted seems to tend to defer changes to ext4.
And in this case, Ted applied other patches
before mine.

The issues at hand are simply normal patch
conflict resolution and taste.  Ted's free
to do what he wants with patches he receives.

Accept/reject/ridicule/ignore/defer, etc...
Whatever, it doesn't bother me.

My patch applies cleanly on -next (ext4 #dev)
as of the date I sent it.  I can not do more
than that except to resend it after resolving
the conflicts.  I see no real good reason to
do that currently.  There are no patches from
you for ext4 between the patch I sent and now.

cheers, Joe
