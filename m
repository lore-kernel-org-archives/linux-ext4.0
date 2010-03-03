From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [LSF/VM TOPIC] Re: [Lsf10-pc] Rich-acl discussion for Linus Storage and Filesystem
 summit
Date: Wed, 03 Mar 2010 19:39:06 +0530
Message-ID: <878wa9o5tp.fsf@linux.vnet.ibm.com>
References: <87hboypy6v.fsf@linux.vnet.ibm.com>
	<1267542978.3099.68.camel@localhost.localdomain>
	<1267607061.15025.11.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lsf10-pc@lists.linuxfoundation.org,
	"linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"Ext4 Developers List" <linux-ext4@vger.kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
	Trond Myklebust <Trond.Myklebust@netapp.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1267607061.15025.11.camel@mulgrave.site>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 03 Mar 2010 14:34:21 +0530, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Tue, 2010-03-02 at 10:16 -0500, Trond Myklebust wrote:
> > On Tue, 2010-03-02 at 20:28 +0530, Aneesh Kumar K.V wrote: 
> > > Hi,
> > > 
> > > Suggestion for discussion at LSF summit:
> > > 
> > > Rich-acl patches posted at 
> > > http://article.gmane.org/gmane.comp.file-systems.ext4/17414 helps in
> > > defining a new acl format for Linux that can interoperate better with
> > > NFSv4 acl and CIFS acl. I would like have a discussion on the new acl
> > 
> > What about NTFS?
> > 
> > > format, rules regarding how to handle file mode changes and acl
> > > values. Also how to handle uid to nfs name@domain mapping
> > > 
> > > -aneesh
> > 
> > I very much second this proposal. We've been spinning our wheels on the
> > issue of support for non-posix draft acls for far too long.
> 
> So could we take the proposal to the relevant list to see who else wants
> to talk about it and whether any of the ground work can be covered
> beforehand?
> 

Adding fsdevel, ext4 list. samba will also be interested, but that is
subscriber only list

-aneesh
