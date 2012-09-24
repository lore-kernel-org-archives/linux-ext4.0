From: Jan Kara <jack@suse.cz>
Subject: Re: ext4_readdir ignores filldir error code
Date: Mon, 24 Sep 2012 17:07:34 +0200
Message-ID: <20120924150734.GE12264@quack.suse.cz>
References: <CALLzPKYO=Ccajri9Yv5OsZ=Z9X3=4n9NacqNmx4QC_Ra8yPpqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALLzPKYO=Ccajri9Yv5OsZ=Z9X3=4n9NacqNmx4QC_Ra8yPpqQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

On Mon 24-09-12 15:47:24, Kasatkin, Dmitry wrote:
> I noticed following in ext4_readdir() and in other file systems..
> 
> filldir returns error in "error":
>        error = filldir(dirent, de->name, ...)
> 
> But function itself returns "ret"
> 
> What I can see is that when filldir fails, ext4_readir quits, but with
> no error....
>        while (!error && !stored && filp->f_pos < inode->i_size) {
> 
> 
> Is it by design or an error?
  It works as designed (although I agree that the design is a bit odd).
Note that filler functions also set dirent->error which is then used by
e.g. getdents() syscall to set return value.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
