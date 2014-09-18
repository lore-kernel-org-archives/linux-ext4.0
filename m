From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Don't check quota format when there are no
 quota files
Date: Thu, 18 Sep 2014 01:13:35 -0400
Message-ID: <20140918051335.GG24887@thunk.org>
References: <1410899905-32290-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1410899905-32290-1-git-send-email-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 16, 2014 at 10:38:24PM +0200, Jan Kara wrote:
> The check whether quota format is set even though there are no
> quota files with journalled quota is pointless and it actually
> makes it impossible to turn off journalled quotas (as there's
> no way to unset journalled quota format). Just remove the check.
> 
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
