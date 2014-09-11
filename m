From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/5] ext4: Don't use MAXQUOTAS value
Date: Thu, 11 Sep 2014 11:16:14 -0400
Message-ID: <20140911151614.GA26178@thunk.org>
References: <1410376972-18417-1-git-send-email-jack@suse.cz>
 <1410376972-18417-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1410376972-18417-3-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 10, 2014 at 09:22:49PM +0200, Jan Kara wrote:
> MAXQUOTAS value defines maximum number of quota types VFS supports.
> This isn't necessarily the number of types ext4 supports. Although ext4
> will support project quotas, use ext4 private definition for consistency
> with other filesystems.
> 
> CC: linux-ext4@vger.kernel.org
> CC: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied in the ext4 tree, thanks.

					- Ted
