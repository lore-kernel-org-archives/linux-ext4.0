From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2 00/16]  New ACL format for better NFSv4 acl interoperability
Date: Tue, 20 Jul 2010 20:53:36 +0530
Message-ID: <m3y6d6b2iv.fsf@linux.vnet.ibm.com>
References: <1278096227-16784-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <201007192119.50868.agruen@suse.de> <m34ofucxes.fsf@linux.vnet.ibm.com> <201007201211.53289.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sfrench@us.ibm.com, ffilz@us.ibm.com, adilger@sun.com,
	sandeen@redhat.com, tytso@mit.edu, bfields@citi.umich.edu,
	jlayton@redhat.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andreas Gruenbacher <agruen@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201007201211.53289.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 20 Jul 2010 12:11:53 +0200, Andreas Gruenbacher <agruen@suse.de> wrote:
> On Tuesday 20 July 2010 11:31:07 Aneesh Kumar K. V wrote:
> > We need to update ACL4_VALID_FLAGS to now consider ACL4_MASKED as a
> > valid flag.  This is also needed for userspace.
> 
> Good point, I missed that.

I updated the patch and will push the change to korg after running some
test.

> 
> > On a related note, should we move ACL4_MASKED and ACL4_POSIX_MAPPED to
> > be the higher bits ? That would make sure we will be able to accomodate
> > new flag value NFSv4 define.
> 
> That makes sense, except that ACL4_POSIX_MAPPED hasn't entered the scene in 
> the patches posted here, and I'm still not convinced that we'll actually need 
> it.
> 

The userspace change did result in a different output for the below ex:

richacl --set 'flags:a 101:w::deny 101:rw::allow 101:w:a:deny 101:rw:a:allow' f

this now gives

/mnt/d# richacl  --get --numeric  f
f:
 flags:a
   101:-w-----------::deny
   101:rw-----------::allow
   101:-w-----------:a:deny
   101:rw-----------:a:allow

that 'w' in rw::allow is redundant, because we have a deny entry before.

-aneesh
