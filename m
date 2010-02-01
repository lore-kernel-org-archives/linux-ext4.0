From: "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: Re: [PATCH 03/23] vfs: rich ACL in-memory representation and
	manipulation
Date: Mon, 1 Feb 2010 18:06:45 -0500
Message-ID: <20100201230645.GO19418@fieldses.org>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1265002505-8387-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20100201072852.GA17309@cynthia.pants.nu>
	<87y6jczve4.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, adilger@sun.com, tytso@mit.edu, jlayton@redhat.com,
	Brad Boyer <flar@allandria.com>, nfsv4@linux-nfs.org,
	samba@lists.samba.org, ffilz@us.ibm.com, sfrench@us.ibm.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, agruen@suse.de
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <nfsv4-bounces@linux-nfs.org>
Content-Disposition: inline
In-Reply-To: <87y6jczve4.fsf@linux.vnet.ibm.com>
List-Unsubscribe: <http://linux-nfs.org/cgi-bin/mailman/options/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=unsubscribe>
List-Archive: <http://linux-nfs.org/pipermail/nfsv4>
List-Post: <mailto:nfsv4@linux-nfs.org>
List-Help: <mailto:nfsv4-request@linux-nfs.org?subject=help>
List-Subscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=subscribe>
Sender: nfsv4-bounces@linux-nfs.org
Errors-To: nfsv4-bounces@linux-nfs.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Feb 01, 2010 at 11:32:59PM +0530, Aneesh Kumar K. V wrote:
> I guess id mapping needs more work in the patch. I would really like
> to hear from both NFS and Samba people in how they would like the
> id details to be stored. If we can't map an incoming user@domain
> request on nfs, I guess we definitely don't want to store the acl with
> 'nobody' id

I don't see the point in allowing the acl's to refer to arbitrary
user@domain strings unless we're also going to allow those strings as
file owners, allow processes to run *as* one of those strings, etc.

If we're really going to try to teach the core kernel to handle foreign
NFS or Samba identities, that's a separate project.

As long as the kernel's working with ordinary uid's and gid's, the acl's
should do the same, and NFS and Samba can take care of the conversion as
needed.

So I agree that we should be able to use a more compact representation
here.

--b.
