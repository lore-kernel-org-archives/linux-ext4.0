From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4/001: Select different output based on mount
 options
Date: Mon, 7 Dec 2015 18:26:31 -0500
Message-ID: <20151207232631.GD3094@thunk.org>
References: <1448361598-28438-1-git-send-email-jack@suse.cz>
 <1448361598-28438-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.com>
To: Jan Kara <jack@suse.cz>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1448361598-28438-4-git-send-email-jack@suse.cz>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 24, 2015 at 11:39:58AM +0100, Jan Kara wrote:
> From: Jan Kara <jack@suse.com>
> 
> Depending on mount options, we handle unwritten extents somewhat
> differently. So sometimes we end up zeroing out unwritten extent and
> converting it to written one and sometimes we just split it. Choose
> expected output based on mount options.
> 
> Signed-off-by: Jan Kara <jack@suse.com>

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

						- Ted
