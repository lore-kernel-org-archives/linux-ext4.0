From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4_has_free_blocks always checks cap_sys_resource and makes
 SELinux unhappy
Date: Fri, 24 Oct 2008 11:56:09 -0500
Message-ID: <4901FE29.3090600@redhat.com>
References: <1224860735.3404.74.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, selinux@tycho.nsa.gov,
	sds@tycho.nsa.gov, esandeen@redhat.com, tytso@mit.edu,
	dwalsh@redhat.com, linux-security-module@vger.kernel.org
To: Eric Paris <eparis@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1224860735.3404.74.camel@localhost.localdomain>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Paris wrote:
> I'm running an ext4 root filesystem and regularly get SELinux denials
> like:
> 
> Oct 16 08:32:55 localhost kernel: type=1400 audit(1224160369.076:5):
> avc: denied  { sys_resource } for  pid=1624 comm="dbus-daemon"
> capability=24 scontext=system_u:system_r:system_dbusd_t:s0
> tcontext=system_u:system_r:system_dbusd_t:s0 tclass=capability
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=467216
> 
> Since this doesn't happen with people who have ext3 filesystems but
> everything else the same it lead me to look at ext4.  I see that
> ext?_has_free_blocks() has changed since ext3 and now we always check
> for capable(CAP_SYS_RESOUCE).  If a process actually has the capability
> in pE (as many root processes would) but doesn't have the capability in
> SELinux policy we will get a denial.
> 
> I can think of a couple ways to fix this:
> 
> the first (and one I like) is to change ext4 to stop checking
> CAP_SYS_RESOURCE all the time.  It's not really 'pretty' but I think you
> would actually get a better performing function.  Just always calculate
> root_blocks and if we don't have enough room then then do the whole
> check to see if are root and recalculate without root_blocks.  I'd guess
> that a great majority of the time operations will succeed even with a
> non-zero root_blocks and I would guess that most process aren't going to
> be root processes and so we would be calculating root_blocks anyway.
> This would (like ext3) only cause these denials when it was filled up.
> We've been living with that forever, so I don't see a problem there...

Thanks Eric, I'll look into this.  It seems that ext4_has_free_blocks is
now overly complex; it used to return how many blocks are available, if
that number is < nblocks, but the single caller now only checks
success/failure for having nblocks free.  I'll see if I can simplify it
and delay the cap check as you suggest.

-Eric
