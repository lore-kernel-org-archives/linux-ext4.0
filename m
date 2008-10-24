From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: ext4_has_free_blocks always checks cap_sys_resource and makes
	SELinux unhappy
Date: Fri, 24 Oct 2008 11:08:19 -0400
Message-ID: <1224860899.9353.6.camel@moss-spartans.epoch.ncsc.mil>
References: <1224860735.3404.74.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, selinux@tycho.nsa.gov,
	esandeen@redhat.com, tytso@mit.edu, dwalsh@redhat.com,
	linux-security-module@vger.kernel.org
To: Eric Paris <eparis@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1224860735.3404.74.camel@localhost.localdomain>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2008-10-24 at 11:05 -0400, Eric Paris wrote:
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
> 
> The second way would be a new lsm hook.  Instead of calling capable(),
> ext4 could call something like a new capable_noaudit() which would
> return the same result but would tell the lsm that this isn't a security
> decision and shouldn't be audited.  The LSM doesn't currently have any
> kind of syntax or representation like this exposed to the main kernel,
> so I'm a little skeptical how the LSM community at large would respond
> to exposing such a thing...
> 
> Another would be a new specific LSM call to just check cap_sys_resource
> which also doesn't get audited.
> 
> Do others have thoughts?

Seems similar to the vm_enough_memory() case, where we likewise
introduced a separate security hook that internally checks without
auditing.

The OOM killer likewise ought to be using a non-auditing form of
capability checks.

-- 
Stephen Smalley
National Security Agency

