From: Jan Kara <jack@suse.cz>
Subject: Re: default ext3 journal mode - time to poke at this again?
Date: Mon, 20 Jul 2009 20:57:31 +0200
Message-ID: <20090720185731.GA9002@atrey.karlin.mff.cuni.cz>
References: <4A61C60D.5090702@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	"Stephen C. Tweedie" <sct@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A61C60D.5090702@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,

> At the linux symposium this week, some of us were wondering when it 
> would be safe to try and default ext3's default journal mode back to 
> sanity given that all (?) distros immediately reverted the default to 
> data writeback mode.
  Well, at least SUSE still uses data=ordered,barrier as a default (and
I personally think this is the right thing to do). Hmm, maybe you've
meant this and just wrote it otherwise given your paragraph below ;)

> Failing that, can we at least clean up the config option description to 
> properly give the normal users a non-bogus, technical description of the 
> trade off ?
  Yes, I'm all for it. Will you try to write up something or should I?

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
