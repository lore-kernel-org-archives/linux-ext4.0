From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] vfs: Add additional owner identifier
Date: Thu, 11 Mar 2010 07:01:52 -0500
Message-ID: <20100311120152.GA4706@infradead.org>
References: <1267727677-11956-1-git-send-email-dmonakhov@openvz.org> <1267727677-11956-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1267727677-11956-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Mar 04, 2010 at 09:34:33PM +0300, Dmitry Monakhov wrote:
> This patch add project inode identifier. Project ID may be used as
> auxiliary owner specifier in addition to standard uid/gid.

There's really no reason to make this a config option.  And xattrs
are a rather bad interfaces to this, so even if a filesystem has to
resort to implement the project ID this way, this should be hidden
inside the filesystem.

