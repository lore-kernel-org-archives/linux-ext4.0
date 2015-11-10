From: Jan Kara <jack@suse.cz>
Subject: Re: [GIT PULL] ext2 changes for 4.4-rc1
Date: Tue, 10 Nov 2015 10:08:07 +0100
Message-ID: <20151110090807.GD26699@quack.suse.cz>
References: <20151109130944.GE11149@quack.suse.cz>
 <CA+55aFw4=oN0bwJKUnSNzypVAQWCAH7h5-bF2zAhTxNmV2Xt6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFw4=oN0bwJKUnSNzypVAQWCAH7h5-bF2zAhTxNmV2Xt6Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 09-11-15 17:40:11, Linus Torvalds wrote:
> On Mon, Nov 9, 2015 at 5:09 AM, Jan Kara <jack@suse.cz> wrote:
> >
> > to get fixes for DAX for ext2 and a minor fixup for ext4 Kconfig
> > description (leftover from ext3 removal).
> 
> You already sent the ext4 Kconfig fix earlier..

Yeah, sorry. I forgot to update my master branch (tracking your tree)
before generating a pull request and so I didn't see you've merged that
Kconfig change. I thought the pull request just got lost somewhere.

I've added automatic update of master into the script generating pull
request so it should not happen anymore.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
