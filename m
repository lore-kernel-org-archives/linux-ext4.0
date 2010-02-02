From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 11/23] richacl: Move the xattr representation to
	little-endian format
Date: Tue, 02 Feb 2010 11:05:51 +0530
Message-ID: <87tyu042tk.fsf@linux.vnet.ibm.com>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1265002505-8387-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20100201233429.GU19418@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, adilger@sun.com, tytso@mit.edu, jlayton@redhat.com,
	nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org,
	sfrench@us.ibm.com, ffilz@us.ibm.com, linux-ext4@vger.kernel.org,
	agruen@suse.de
To: "J. Bruce Fields" <bfields@citi.umich.edu>
Return-path: <nfsv4-bounces@linux-nfs.org>
In-Reply-To: <20100201233429.GU19418@fieldses.org>
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

On Mon, 1 Feb 2010 18:34:29 -0500, "J. Bruce Fields" <bfields@citi.umich.edu> wrote:
> On Mon, Feb 01, 2010 at 11:04:53AM +0530, Aneesh Kumar K.V wrote:
> > Posix acl already use little-endian representation on disk. Move
> > richacl also to little-endian representation
> 
> Merge this back into patch #3?
> 
>

Yes. We should be merging some of these patches into earlier patches. I
want to keep the patches separate at this point to enable Andreas to
find out the changes done to original path so that he should be able to
review them easily. But yes before we can merge this to upstream some
of this patches to be folded back to earlier patches.

-aneesh
