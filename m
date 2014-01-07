From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: avoid clearing beyond i_blocks when truncating an
 inline data file
Date: Tue, 7 Jan 2014 12:58:39 -0500
Message-ID: <20140107175839.GF2822@thunk.org>
References: <1389117437-12060-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1389117437-12060-1-git-send-email-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 07, 2014 at 12:57:17PM -0500, Theodore Ts'o wrote:
> A missing cast means that when we are truncating a file which is less
> than 60 bytes, we don't trunate the wrong area of memory, and in fact
> we can end up truncating the next inode in the inode table, or worse
> yet, some other kernel data structure.

s/trunate the wrong/clear the correct/

						- Ted
