From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Sat, 9 Aug 2014 20:09:51 -0400
Message-ID: <20140810000951.GI15431@thunk.org>
References: <CAPTn0cAKi64Fh1pAVTDLvSS5-1Kjv7KN2HpGxtm4J8-ym-4nOQ@mail.gmail.com>
 <20140808223335.GQ25145@thunk.org>
 <CAPTn0cCwczoaH7va4x3yJZBgtRr8b7_eG9V0YO16YzQcnshdTA@mail.gmail.com>
 <20140809172427.GF15431@thunk.org>
 <20140809221710.GH15431@thunk.org>
 <20140809233832.GM20518@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@zeniv.linux.org.uk, hch@infradead.org,
	Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	"Niu, Yawei" <yawei.niu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140809233832.GM20518@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Aug 10, 2014 at 09:38:32AM +1000, Dave Chinner wrote:
> 
> I've seen this sort of thing quite a bit over the past 10 years.
> Most of the time on storage systems measured in the high tens to
> hundreds of TB of storage, which puts it way out of the scope of
> knowledge of most Linux distro and application developers. That's
> most likely why you don't get any other answer to your questions -
> most people can't see how project quotas get used because they've
> never worked in a large, multi-project environment before.

Sure, but the people who are advocating for project quotas had better
understand how they plan to use them, both so that (a) if they do a
design different from XFS, they can justify why the differences are
necessary, and (b) to justify whether we need it in ext4 to begin
with.

The "directory hierarchy quota" is easy to understand, it's something
that the Andrew File System had --- down to restriction that you can't
move a file between different AFS volumes, but instead have to copy
and unlink.

> If we need a more *complex* solution because people need more than
> just what the simple solution gives them, then that is a topic for
> -fsdevel and probably LSFMM because there's all sorts of semantic
> and interface discussions that are needed and a lot more code that
> needs to be written. i.e. the simple solution can be deployed within
> a couple of kernel releases, a generic solution is more likely a
> coupleof *years* of work to deploy...

100% agreed.  And I have yet to see a compelling case that even the
simple form of project id's would get a lot of use in the ext4 world.
Which is why I want to know from those who want to add project quotas
in to ext4.  How do you plan to use them?  What's the use case
scenario?

							- Ted
