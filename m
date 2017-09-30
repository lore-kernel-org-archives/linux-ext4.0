From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH v2] VFS: Handle lazytime in do_mount()
Date: Sat, 30 Sep 2017 09:10:22 +0200
Message-ID: <20170930071022.GA238@x4>
References: <20170918192644.GA232@x4>
 <20170919083506.GA233@x4>
 <20170919101819.GA233@x4>
 <20170919103724.GA239@x4>
 <20170919152500.ce62nirm7gu3lqvq@rh_laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170919152500.ce62nirm7gu3lqvq@rh_laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2017.09.19 at 17:25 +0200, Lukas Czerner wrote:
> On Tue, Sep 19, 2017 at 12:37:24PM +0200, Markus Trippelsdorf wrote:
> > Since commit e462ec50cb5fa ("VFS: Differentiate mount flags (MS_*) from
> > internal superblock flags") the lazytime mount option didn't get passed
> > on anymore.
> > 
> > Fix the issue by handling the option in do_mount().
> > 
> > Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> > ---
> >  fs/namespace.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/namespace.c b/fs/namespace.c
> > index 54059b142d6b..b633838b8f02 100644
> > --- a/fs/namespace.c
> > +++ b/fs/namespace.c
> > @@ -2823,7 +2823,8 @@ long do_mount(const char *dev_name, const char __user *dir_name,
> >  			    SB_MANDLOCK |
> >  			    SB_DIRSYNC |
> >  			    SB_SILENT |
> > -			    SB_POSIXACL);
> > +			    SB_POSIXACL |
> > +			    SB_LAZYTIME);
> 
> Looks good. Although I still think that this can be per mountpoint options.
> 
> Regardless of that, you can add
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Ping?
Al could you please take look? 
Thanks.

-- 
Markus
