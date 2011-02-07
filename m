From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Mon, 7 Feb 2011 08:35:31 -0800
Message-ID: <946A4527-3A1C-4EC5-BEAC-4E47F3CFDF01@dilger.ca>
References: <20110203144011.GA28409@quack.suse.cz> <4D4AC4E2.701@redhat.com> <20110204130313.GB4104@quack.suse.cz> <316721F8-70CD-4E29-A94E-BFEF2D762829@dilger.ca> <20110207161933.GB5337@quack.suse.cz>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	ext4 List <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110207161933.GB5337@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2011-02-07, at 08:19, Jan Kara wrote:
> On Fri 04-02-11 10:36:21, Andreas Dilger wrote:
>> The question is whether we need to mimic the runtime behavior or just the
>> on-disk format?  Apps already need to deal with ext4 and other fs that do
>> not do ext3 ordered mode.
> 
>  Well written apps do, but badly written apps don't and e.g. our distro
> customers don't always have the choice of the application. So as a developer
> I see your point (screw stupidly written apps) but in the real world, I'm
> afraid it's too hard on users.

We have to remember that this is only for new kernels, and does not affect older kernels or existing applications, so such users shouldn't be affected.

>> I think the best road forward is to make ext4 the default for ext2 and
>> ext3 filesystems in newer kernels, and mark ext2 and ext3 obsolete. This
>> will start to get usage and testing of these other config options. The
>> ext2 mode is already heavily tested at Google, and don't they also test
>> noextent mode on updated filesystems, or were all of the filesystems
>> reformatted with ext4 options?
> 
>  Yes, I know you are on relatively radical side ;). My position would be
> to test ext4 for resonable combinations of options as ext2 driver and if
> that works, switch ext2 as you describe. Then if it works fine for an year
> or so, we can talk about ext3 but as James said, ext3 is still widely used
> so there might be more friction on subtle runtime differences...

Since most new distros use ext4 by default, the point is kind of moot, because those users will get this behaviour in any case.  Relatively few users upgrade their kernel on a production system after it is installed, except for errata kernels, and I definitely wouldn't expect such a change to appear in an errata kernel.

Cheers, Andreas





