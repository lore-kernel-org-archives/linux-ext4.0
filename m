From: tytso@mit.edu
Subject: Re: [PATCH 3/4] ext4: update ctime when changing the file's
 permission by setfacl
Date: Tue, 15 Jun 2010 12:21:29 -0400
Message-ID: <20100615162129.GB6463@thunk.org>
References: <1275664075-4703-1-git-send-email-jack@suse.cz>
 <1275664075-4703-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1275664075-4703-4-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 04, 2010 at 05:07:54PM +0200, Jan Kara wrote:
> ext4 didn't update the ctime of the file when its permission was changed.

I've added this to the ext4 tree, thanks.

						- Ted
