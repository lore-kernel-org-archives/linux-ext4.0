From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Patch 1/13] iostats
Date: Tue, 24 Jul 2007 10:29:50 -0400
Message-ID: <20070724142950.GB11826@thunk.org>
References: <1185275076.3789.66.camel@dhcp4.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Girish Shilamkar <girish@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33431 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbXGXO3z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jul 2007 10:29:55 -0400
Content-Disposition: inline
In-Reply-To: <1185275076.3789.66.camel@dhcp4.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 24, 2007 at 04:34:36PM +0530, Girish Shilamkar wrote:
>  
> +struct struct_io_stats {
> +	unsigned long long reads;
> +	unsigned long long writes;
> +};

I'd suggest doing something like this instead:

struct struct_io_stats {
	int	num_fields;
	int	reserved;
	unsigned long long bytes_read;
	unsigned long long bytes_written;
};

There are other statistics that you might want to gather.  For
example, "read_requests" and "write_requests".  Or perhaps some
statistics based on discontiguous read/writes (i.e., i/o operations
that cause seeks).  Also, in the future we might want to add some kind
of readahead functionality, and that would probably require more
statistics as well.

> +	memset(&track->io_start, 0, sizeof(struct struct_io_stats));
> +	if (channel && channel->manager && channel->manager->get_stats)
> +		channel->manager->get_stats(channel, &track->io_start);
>  }

If you're going to use a caller allocates paradigm, then the caller
would be responsible for doing this:

      track->io_start.num_fields = 2;

... so the library routine knows how much of the structure it is safe
for it to fill in.  Alternatively, it might be easier to simply have
the io_manager pass back a pointer to its own stats structure, and
then the caller would use the num_fields_size to figure out how much
of the structure it can trust.

						- Ted
