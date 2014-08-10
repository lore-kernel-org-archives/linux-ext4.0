From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Sun, 10 Aug 2014 10:15:36 +0800
Message-ID: <CAPTn0cBQZsXfcC5FL17s48REGiO0YnQiZB0ez6neCmQr3V5Z4Q@mail.gmail.com>
References: <CAPTn0cAKi64Fh1pAVTDLvSS5-1Kjv7KN2HpGxtm4J8-ym-4nOQ@mail.gmail.com>
	<20140808223335.GQ25145@thunk.org>
	<CAPTn0cCwczoaH7va4x3yJZBgtRr8b7_eG9V0YO16YzQcnshdTA@mail.gmail.com>
	<20140809172427.GF15431@thunk.org>
	<20140809221710.GH15431@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@zeniv.linux.org.uk, hch@infradead.org,
	Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	"Niu, Yawei" <yawei.niu@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140809221710.GH15431@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> An additional philosophical question.  If your argument is that you
> want project quotas to be as fully general and to work like group
> quotas --- then this brings up a fundamental question --- why can't
> you just use group quotas?
I think the reason that people want another quota type is that the UID/GID
is used in privilege management. And it is always troublesome when things
are related to privilege, because no administrator want to be blamed for
file access from unauthorized users. UID/GID usually has a determined
mapping rule to customers in reality. In this sense, I don't think
administrators want to (or can) change user/group settings frequently.
And that is why we need an extra quota type. It looks like group quota,
but it is flexible and safer for management.
>
> What is the use case where you need to have two different quotas that
> work exactly like group quotas?  And following in the general design
> rule of "Zero, one, or infinity: there is no two", for whatever use
> case where you might argue that you need _two_ quotas with identical
> semantics as group quotas, who is to say that there won't be someone
> that comes up with some other use case where you need _three_ quotas
> with identical semantics as group quotas.  Or _four_ group quotas
> being tracked simultaneously.  Etc, etc., etc.
"Zero, one, or infinity: there is no two" looks like a beautiful philosophy.
I totally agree on that. However, I think general project quota happens to
be the one, not two. If it is an acceptable conclusion that administrator
can't change global group settings and group attributes of inodes frequently,
project quota become the first flexible and fully controled quota type,
which administrators can use for freewill space accountment and limit
enforcement. Unfortunately, this feature has been missing for such a long
time and the requirement for it grows to a critical point that a lot of
distributed file systems find their own way of providing similar features,
e.g. directory/volume/file-set/project quotas. These features looks
extremely familar, yet aim at different use cases and havs different
restraints. I prefer a version without any unnecessary restraints becasue
it retains all possibility.
>
> The advantage of doing the directory hierarcy based quota system is
> not just that it's compatible with XFS; it is that it is *different*
> from group quotas.  Not more restrictive, but *different*.  There will
> certainly be scenarios where someone wants to enforce a restriction on
> the size or number of inodes in a directory hierarcy, and where when
> you move a file out of a directory hierarcy into another one, you
> *want* the usage quota to be transfered from the source to the
> destination hierarcy.
I agree that project quota and group quota is different. And I gree that
the use case of enforcing directory-tree quota is a very important use case,
probably the most important use case. What I am suggesting is that, with an
unlimited general project quota, we can enable other potential use cases
without harming this use case at all. For example, if we want to move
a file out of a directory hierarcy into another and want the usage quota
to be transfered, why can't we add a 'setproject' command following with
'rename/mv' command? In this use case, this operation is usually done by
administrator. And I guess it can be safely assumed that a administrator
is well trained to know what should be done when managing project related
directories.
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
Yeah, that is truely a problem. However, I don't think it is possible
for a feature to limit how it can be used. Even we set the restraints
for project quota feature, the project ID can still be messed by multiple
selfish applications any way.
> case what you want really *is* based on directory hierarcies --- or
> you make it be something fully general, where these different quota
> types are stored as extended attributes, so you can have multiple
> different namespaces --- one for the Parallel's container group name,
> for the container quota system; another one for the GNOME use of the
> "project quota", and so instead of having a single "project quota"
> inode, let that reserved inode be used for a directory, so you can
> have multiple "quota inodes" for the different dimensions of quota
> usage.
Again, without project quota, administrators do not have any similar tool.
Either they get project quota, or nothing. So, what we are concerned now is
to provide project quota as the first 'one'. When it turns out project
is not enough any more in the future, we definitely need to provide
'infinity'. :)

Regards,
                                                        -Li Xi
