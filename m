From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 2/4] ext4: fix in-superblock mount options processing
Date: Fri, 18 Nov 2016 12:27:33 -0800
Message-ID: <20161118202733.GA100623@google.com>
References: <20161118183842.25682-1-tytso@mit.edu>
 <20161118183842.25682-2-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, kernel@kyup.com,
        bp@alien8.de, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161118183842.25682-2-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 18, 2016 at 01:38:40PM -0500, Theodore Ts'o wrote:
> Fix a large number of problems with how we handle mount options in the
> superblock.  For one, if the string in the superblock is long enough
> that it is not null terminated, we could run off the end of the string
> and try to interpret superblocks fields as characters.  It's unlikely
> this will cause a security problem, but it could result in an invalid
> parse.  Also, parse_options is destructive to the string, so in some
> cases if there is a comma-separated string, it would be modified in
> the superblock.  (Fortunately it only happens on file systems with a
> 1k block size.)
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@vger.kernel.org

Reviewed-by: Eric Biggers <ebiggers@google.com>
