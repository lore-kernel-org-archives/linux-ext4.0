From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: do not advertise encryption support when disabled
Date: Wed, 12 Oct 2016 23:26:30 -0400
Message-ID: <20161013032630.wff6nj52xaf6gear@thunk.org>
References: <1476126331-82810-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, richard@nod.at
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1476126331-82810-1-git-send-email-ebiggers@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 10, 2016 at 12:05:31PM -0700, Eric Biggers wrote:
> The sysfs file /sys/fs/ext4/features/encryption was present on kernels
> compiled with CONFIG_EXT4_FS_ENCRYPTION=n.  This was misleading because
> such kernels do not actually support ext4 encryption.  Therefore, only
> provide this file on kernels compiled with CONFIG_EXT4_FS_ENCRYPTION=y.
> 
> Note: since the ext4 feature files are all hardcoded to have a contents
> of "supported", it really is the presence or absence of the file that is
> significant, not the contents (and this change reflects that).
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
