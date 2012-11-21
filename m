From: Jeffrey Ellis <jellis@dhnet.us>
Subject: Re: [PATCH 1/9] vfs: Handle O_SYNC AIO DIO in generic code properly
Date: Wed, 21 Nov 2012 18:09:48 -0500
Message-ID: <293D7CE0-C899-43F8-B04E-EB31100C8888@dhnet.us>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org> <20121120074123.24645.41965.stgit@blackbox.djwong.org> <20121121100809.GE23339@infradead.org> <x497gpevqoy.fsf@segfault.boston.devel.redhat.com> <20121121182901.GA4519@infradead.org> <20121121213732.GG30250@quack.suse.cz>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	"bpm@sgi.com" <bpm@sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Jeff Moyer <jmoyer@redhat.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"jack@suse.cz" <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121121213732.GG30250@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Best,
J. 

On Nov 21, 2012, at 4:37 PM, Jan Kara <jack@suse.cz> wrote:

> On Wed 21-11-12 13:29:01, Christoph Hellwig wrote:
>> On Wed, Nov 21, 2012 at 11:58:05AM -0500, Jeff Moyer wrote:
>>>> I'd like to use this as a vehicle to revisit how dio completions work.
>>> 
>>> I don't like the sound of that.  ;-)  It sounds like this bugfix may get
>>> further delayed by the desire for unrelated code cleanup.
>> 
>> I've got a prototype that isn't much more invasive than the current
>> series.  I'll finish it up and run it through QA and will post it
>> tomorrow.
>  Great, I wanted to have a look into it but you beat me to it ;)
> 
>                                Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
