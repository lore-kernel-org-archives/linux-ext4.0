From: Shuichi Ihara <sihara@ddn.com>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Sun, 10 Aug 2014 08:38:25 +0000
Message-ID: <9D6138C7-3716-4A15-8269-5194B6F29AC7@ddn.com>
References: <CAPTn0cAKi64Fh1pAVTDLvSS5-1Kjv7KN2HpGxtm4J8-ym-4nOQ@mail.gmail.com>
 <20140808223335.GQ25145@thunk.org>
 <CAPTn0cCwczoaH7va4x3yJZBgtRr8b7_eG9V0YO16YzQcnshdTA@mail.gmail.com>
 <20140809172427.GF15431@thunk.org> <20140809221710.GH15431@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Li Xi <pkuelelixi@gmail.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>,
	"Niu, Yawei" <yawei.niu@intel.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140809221710.GH15431@thunk.org>
Content-Language: en-US
Content-ID: <47FCE0D6E04B294CBC39D0C90AD3726E@ddn.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

One of our (Li Xi and ourself) purpose of what we need project quota support in ext4, is project quota support in the Lustre filesystem.
Lustre has been running as high performance parallel filesystem for mainly scratch space of HPC system per organization, site, or group. So, organization/site level UID/GID quota might be enough.

However, recently, multiple sites, groups or organizations are using the same Lustre filesystem for not only scratch space, but also a several variety of use cases and reasons. 
The other hand, filesystem size is getting larger and larger, people (include users and administrator) prefer single namespace as performance and simple administration perspective rather than managing many small filesystems. (it helps reducing copy costs from filesystem to filesystem)

Therefore, even under the same GID, they have different projects/purposes on the filesystem and are involved in these several projects. And also, sometimes, the budgets are allocated to each project or tasks. (or multiple projects and tasks) If they have huge budgets, administrator can allocate a lot of storage resources to that project, but it's less budgets, less storage resource allocation for fair cost/resource management. In this use case, it's very harder of storage management with GID based quota.

Although Lustre is distributed filesystem, it's based on aggregated local filesystem, mainly ext4 today. And, Lustre quota has cluster wide quota mechanism/management, but it relies on the backend local filesystem's quota. Now, additional "id" for different type of quota accounting (project) is required in ext4 to cover above new type of quota management that can't be easy handling with UID/GID, today....

Regards,
Ihara

On Aug 10, 2014, at 7:17 AM, Theodore Ts'o <tytso@mit.edu> wrote:

> An additional philosophical question.  If your argument is that you
> want project quotas to be as fully general and to work like group
> quotas --- then this brings up a fundamental question --- why can't
> you just use group quotas?
> 
> What is the use case where you need to have two different quotas that
> work exactly like group quotas?  And following in the general design
> rule of "Zero, one, or infinity: there is no two", for whatever use
> case where you might argue that you need _two_ quotas with identical
> semantics as group quotas, who is to say that there won't be someone
> that comes up with some other use case where you need _three_ quotas
> with identical semantics as group quotas.  Or _four_ group quotas
> being tracked simultaneously.  Etc, etc., etc.
> 
> The advantage of doing the directory hierarcy based quota system is
> not just that it's compatible with XFS; it is that it is *different*
> from group quotas.  Not more restrictive, but *different*.  There will
> certainly be scenarios where someone wants to enforce a restriction on
> the size or number of inodes in a directory hierarcy, and where when
> you move a file out of a directory hierarcy into another one, you
> *want* the usage quota to be transfered from the source to the
> destination hierarcy.
> 
> It may not be what *you* want, but let me ask you this --- why is it
> that you can't use the group quota system, and need to invent an
> entirely new project quota?  The only excuse I've heard is for people
> who are doing container virtualization.  I don't know if that's your
> reason, but let's examine that use case in detail.  The reason why the
> container virtualization folks want project quotas is because they
> want to have quotas imposed on a portion of the directory hiearchy
> that is given to a customer to use in a chrooted container-style "VM".
> And since the user is going to be using their own user and group id's,
> virtualized using the user and group namespaces, they need a third
> dimension, called project id's.  
> 
> That's all very fine and good, but if you make it fully general, where
> support for it is in ls, find, a new "chproj" command, etc., it start
> becoming an attractive nuisance which either systemd or GNOME might
> start using for their own nefarious purposes.  And once they start
> using that, and it's incorporated into a Fedora release, now someone
> who wants to run Fedora inside a container, and use project id's for a
> quota system for a container, will collide with the use of project
> id's for Fedora!   Oops.
> 
> And this is where the "zero, one, or infinity" rule comes into play.
> You can either keep project quotas very tightly constrained for a
> single use case --- namely, virtualization for containers, in which
> case what you want really *is* based on directory hierarcies --- or
> you make it be something fully general, where these different quota
> types are stored as extended attributes, so you can have multiple
> different namespaces --- one for the Parallel's container group name,
> for the container quota system; another one for the GNOME use of the
> "project quota", and so instead of having a single "project quota"
> inode, let that reserved inode be used for a directory, so you can
> have multiple "quota inodes" for the different dimensions of quota
> usage.
> 
> Personally, I think this latter approach is way too complicated, and
> I'd much rather implement a single directory hierarcy based quota
> system which is compatible with XFS and has XFS's semantics.  But at
> least this second approach is *fully* general, if you are going to
> argue for a more general solution.
> 
> Regards,
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

