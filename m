From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH] fscrypto: make filename crypto functions return 0 on
 success
Date: Thu, 15 Sep 2016 09:54:12 -0700
Message-ID: <20160915165412.GA52239@jaegeuk>
References: <1473894045-65215-1-git-send-email-ebiggers@google.com>
 <20160915001021.GB50095@jaegeuk>
 <20160915025441.GA80824@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, tytso@mit.edu
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160915025441.GA80824@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 14, 2016 at 07:54:41PM -0700, Eric Biggers wrote:
> On Wed, Sep 14, 2016 at 05:10:21PM -0700, Jaegeuk Kim wrote:
> > Hi Eric,
> > 
> > On Wed, Sep 14, 2016 at 04:00:45PM -0700, Eric Biggers wrote:
> > > Several filename crypto functions: fname_decrypt(),
> > > fscrypt_fname_disk_to_usr(), and fscrypt_fname_usr_to_disk(), returned
> > > the output length on success or -errno on failure.  However, the output
> > > length was redundant with the value written to 'oname->len'.  It is also
> > > potentially error-prone to make callers have to check for '< 0' instead
> > > of '!= 0'.
> > 
> > At a glance, you missed some places like
> > - fscrypt_fname_usr_to_disk() in ext4_symlink() and f2fs_symlink()
> > - fscrypt_fname_disk_to_usr() in dx_show_leaf() and f2fs_fill_dentries()
> > 
> 
> Those callers don't have to be updated because they only check for an error
> value --- they don't use the return value as a length.  I did check all the
> callers of fscrypt_fname_{usr_to_disk,disk_to_usr()}, and only the three I
> update in the patch used the return value as a length.

Hmm, your patch tries to change the return value and make its usage more
consistent. So, I think it should have been considered to change if (err < 0)
to if (err) entirely in order to avoid any potential mistake; this patch already
addresses it in some cases, but not all.

e.g., in f2fs_symlink,

	err = fscrypt_fname_usr_to_disk(inode, &istr, &ostr);
	if (err < 0)
		goto err_out;

BTW, in dx_show_leaf(),
	res = fscrypt_fname_disk_to_usr(dir,
		0, 0, &de_name,
		&fname_crypto_str);
	if (res < 0)
		...

IMHO, it'd be better to use err instead of {res|ret} when considering naming
convention.

Thanks,

> 
> Eric
