From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC 03/13] charsets: utf8: Add unicode character database
 files
Date: Fri, 12 Jan 2018 19:24:07 -0500
Message-ID: <20180113002407.GD8249@thunk.org>
References: <20180112071234.29470-1-krisman@collabora.co.uk>
 <20180112071234.29470-4-krisman@collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: david@fromorbit.com, bpm@sgi.com, olaf@sgi.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel@lists.collabora.co.uk, alvaro.soliverez@collabora.co.uk
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180112071234.29470-4-krisman@collabora.co.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 12, 2018 at 05:12:24AM -0200, Gabriel Krisman Bertazi wrote:
> From: Olaf Weber <olaf@sgi.com>
> 
> Add files from the Unicode Character Database, version 7.0.0, to the source.
> A helper program that generates a trie used for normalization from these
> files is part of a separate commit.

It looks like the latest version of Unicode is 10.0.0.  Once we pick a
Unicode version, changing will be painful; but in the absence of
interop requirements, is there a reason to stick with Unicode 7?  Why
not take the latest version of Unicode and then freeze on it?

    	     	    	       	       	   - Ted
