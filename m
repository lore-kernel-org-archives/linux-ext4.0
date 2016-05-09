From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/6] statx: Add a system call to make enhanced file info
 available
Date: Mon, 09 May 2016 14:00:25 +0100
Message-ID: <31873.1462798825@warthog.procyon.org.uk>
References: <31651.1462798652@warthog.procyon.org.uk>
 <20160508083543.GA14316@infradead.org>
 <20160429125736.23636.47874.stgit@warthog.procyon.org.uk>
 <20160429125743.23636.85219.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: linux-afs@vger.kernel.org, linux-nfs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <31651.1462798652@warthog.procyon.org.uk>
Content-ID: <31872.1462798825.1@warthog.procyon.org.uk>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical/>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Errors-To: samba-technical-bounces@lists.samba.org
Sender: "samba-technical" <samba-technical-bounces@lists.samba.org>
List-Id: linux-ext4.vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > > st_gen is
> > > the inode generation number, st_btime is the file creation time, st_=
version
> > > is the data version number (i_version),
> > =

> > Please define semantics for st_gen and st_version.
> =

> I've been asked to drop st_gen for security reasons.
> =

> I can't offhand think of a way to define st_version (or i_version, for t=
hat
> matter) that would be consistent across all filesystems.  I would lean t=
owards
> "gets incremented monotonically by 1 for each data write operation commi=
tted,
> but not for any metadata operations", but I'm fairly certain this won't =
jibe
> with disk operations.

I meant disk filesystems that we have now, not disk operations.

David
