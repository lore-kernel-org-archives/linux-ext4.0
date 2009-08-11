From: Al Boldi <a1426z@gawab.com>
Subject: Re: [PATCH, RFC] ext3: Update Kconfig description of EXT3_DEFAULTS_TO_ORDERED
Date: Tue, 11 Aug 2009 14:41:01 +0300
Message-ID: <200908111441.01832.a1426z@gawab.com>
References: <1249934623-15939-1-git-send-email-tytso@mit.edu> <200908110649.20277.a1426z@gawab.com> <20090811093316.GA23898@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753440AbZHKMHa@vger.kernel.org>
In-Reply-To: <20090811093316.GA23898@duck.suse.cz>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jan Kara wrote:
> On Tue 11-08-09 06:49:20, Al Boldi wrote:
> > Theodore Ts'o wrote:
> > > +	  "data=ordered" mode can also result in major performance
> > > +	  problems, including seconds-long delays before an fsync()
> > > +	  call returns.	 For details, see:
> > > +
> > > +	  http://ext4.wiki.kernel.org/index.php/Ext3_data_mode_tradeoffs
> >
> > Why isn't the fsync problem fixable?
>
>   Because it's quite deep in the design of JBD: All the modifications done
> to a filesystem go to one transactions. When the transaction grows big
> enough or old enough, we commit the transaction, which means we write all
> the metadata to the journal and all the ordered data to their final
> location on disk. If you do fsync(), you have to wait for a transaction
> commit with your data to finish, so that you are guaranteed a consistent
> state of metadata is on disk. But when there is heavy background writing,
> it means there's a lot of data you have to write out and wait for... It's
> not easy to work around this - naively, you might want to separate out just
> the writes you care about for fsync() but that's not easily possible
> because bitmaps and group descriptors are modified by other writes as well.

Ok, I remember now, that was the konqueror deadlocks problem.  I think making 
the fsync soft in that case would yield a better result than turning 
ordered-mode off completely.

BTW: did you get around fixing the ordered-mode redundant write out problem?


Thanks!

--
Al
