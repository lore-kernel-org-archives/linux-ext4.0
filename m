From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/2] ext4: grab write access inside ext4_file_dio_write
Date: Wed, 20 Mar 2013 12:54:40 +0000
Message-ID: <20130320125440.GN21522@ZenIV.linux.org.uk>
References: <1363783698-28092-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1363783698-28092-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 20, 2013 at 04:48:17PM +0400, Dmitry Monakhov wrote:
> We are responsible hold write count before any fs-speciffic modifications
> This patch should fix following warning:

NAK.  The right way to do it is to lift the damn thing out of ->aio_write()
completely.  See the last 3 commits in vfs.git#experimental...
