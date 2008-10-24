From: Eric Paris <eparis@redhat.com>
Subject: Re: ext4_has_free_blocks always checks cap_sys_resource and makes
 SELinux unhappy
Date: Fri, 24 Oct 2008 13:28:32 -0400
Message-ID: <1224869312.3404.80.camel@localhost.localdomain>
References: <1224860735.3404.74.camel@localhost.localdomain>
	 <1224860899.9353.6.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, selinux@tycho.nsa.gov,
	esandeen@redhat.com, tytso@mit.edu, dwalsh@redhat.com,
	linux-security-module@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1224860899.9353.6.camel@moss-spartans.epoch.ncsc.mil>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2008-10-24 at 11:08 -0400, Stephen Smalley wrote:
> On Fri, 2008-10-24 at 11:05 -0400, Eric Paris wrote:

> > Do others have thoughts?
> 
> Seems similar to the vm_enough_memory() case, where we likewise
> introduced a separate security hook that internally checks without
> auditing.
> 
> The OOM killer likewise ought to be using a non-auditing form of
> capability checks.

So would you suggest a generic non-auditing capability checking
mechanism or a specific hook for "things to use"

* capable_noaudit(current, cap)
* security_capable_noaudit(current, cap)
* security_cap_sys_resource(current)

Looks like oom also checks CAP_SYS_ADMIN so maybe a generic cap
interface would be best.

esandeen: I still think it would be a good idea to simplify
ext4_claim_free_blocks() and ext4_has_free_blocks() which seems to have
a lot of code duplication and both have the unconditional capable
calls...

-Eric

