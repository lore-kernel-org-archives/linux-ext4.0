From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Sun, 10 Aug 2014 12:52:53 -0400
Message-ID: <20140810165253.GJ15431@thunk.org>
References: <CAPTn0cAKi64Fh1pAVTDLvSS5-1Kjv7KN2HpGxtm4J8-ym-4nOQ@mail.gmail.com>
 <20140808223335.GQ25145@thunk.org>
 <CAPTn0cCwczoaH7va4x3yJZBgtRr8b7_eG9V0YO16YzQcnshdTA@mail.gmail.com>
 <20140809172427.GF15431@thunk.org>
 <20140809221710.GH15431@thunk.org>
 <9D6138C7-3716-4A15-8269-5194B6F29AC7@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Li Xi <pkuelelixi@gmail.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>,
	"Niu, Yawei" <yawei.niu@intel.com>
To: Shuichi Ihara <sihara@ddn.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9D6138C7-3716-4A15-8269-5194B6F29AC7@ddn.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Aug 10, 2014 at 08:38:25AM +0000, Shuichi Ihara wrote:
> 
> One of our (Li Xi and ourself) purpose of what we need project quota
> support in ext4, is project quota support in the Lustre filesystem.

OK, but for lustre, you completely bypass the VFS when you write the
back end files.  Yes?  So if implement something which is XFS
compatible vis-a-vis a directory tree quota, it doesn't matter if
Lustre is creating many different files that belong to project id's.


This being said, for this particular use case, I'm not entirely sure
why you can't just create separate groups for each project, and then
let group inheritance take care of things:

mkdir top-level
chgrp project1 top-level
chmod g+s top-level

Now all of the files created in top-level will be accounted in
project1's quota.

If the answer is that it's too easy to evade quota controls by using
the "chgrp" command, note that if you are going to allow users to mv
files around, they can easily evade the project quota anyway, by
creating the file in top-level dirctory of project2, and then mv'ing
it into the top-level directory of project1.

Or are you really saying you really need to simultaneously track quota
from a group perspective, and a project perspectively, at the same
time?  If so, why?

Regards,

					- Ted
