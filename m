From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Ext4: Fix extended timestamp encoding and decoding
Date: Fri, 6 Nov 2015 10:58:35 -0500
Message-ID: <20151106155835.GC6160@thunk.org>
References: <20151105144916.6333.58880.stgit@warthog.procyon.org.uk>
 <20151105181424.GD2213@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>, kalpak@clusterfs.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, arnd@arndb.de
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151105181424.GD2213@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 05, 2015 at 10:14:24AM -0800, Darrick J. Wong wrote:
> ...but I guess nobody ever developed the e2fsprogs regression tests that Ted
> asked for, so none of the patches got merged.  Ho hum.

I haven't forgotten, and it's been put on my "if you want to do it
right, you'll have to do it yourself list".  That plus the fact that
some of my work had hard deadlines in the near-term future (e.g., ext4
encryption), and long-term deadlines, is why it hasn't happened yet.

It is still something that is on my list when I have some free time,
but I would be very happy if someone were willing to help out.

      	       	    	     	     	  - Ted
