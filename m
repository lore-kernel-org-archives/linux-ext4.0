From: Bob Peterson <rpeterso@redhat.com>
Subject: Re: Can one file system be R/W mounted multiple times in Linux?
Date: Fri, 9 Jan 2015 08:25:15 -0500 (EST)
Message-ID: <404451928.6537116.1420809915626.JavaMail.zimbra@redhat.com>
References: <F792CF86EFE20D4AB8064279AFBA51C61EA72765@SIXPRD3002MB028.064d.mgd.msft.net> <20150109035123.GG22149@ZenIV.linux.org.uk> <F792CF86EFE20D4AB8064279AFBA51C61EA727DE@SIXPRD3002MB028.064d.mgd.msft.net> <E09EF4B0-81D8-445C-B921-F920336200AC@redhat.com> <F792CF86EFE20D4AB8064279AFBA51C61EA7288F@SIXPRD3002MB028.064d.mgd.msft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <esandeen@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	linux-fsdevel@vger.kernel.org,
	linux-ext4 <linux-ext4@vger.kernel.org>, stefanha@redhat.com
To: Dexuan Cui <decui@microsoft.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C61EA7288F@SIXPRD3002MB028.064d.mgd.msft.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> > >>> Can somebody please tell me if this usage is safe?
> > >>
> > >> Yes.
> > But to be clear, just in case - this is completely different from, say,
> > mounting the
> > same ext4 fs on two different nodes on a SAN, which is quite certainly not
> > safe...
> > 
> > -Eric
> 
> Thank Eric for pointing this out!
> Can you please explain this?  I didn't use SAN...
> 
> Thanks,
> -- Dexuan

Hi Dexuan,

I think Eric means mounting the same physical device from two different
machines (whether they be VMs or nodes in a cluster, etc.) where shared
storage is involved (like SAN or iSCSI). If one system has no knowledge
of what the other is changing, the file system will likely be corrupted.
It sounds like you're probably not doing that.

However, shared file systems like gfs2 and ocfs2 are designed to allow
simultaneous R/W access from multiple nodes, and the file system metadata
is kept in sync and coherent across the cluster.
I don't know if gfs2 allows multiple mounts from the same machine to
different mount points, due to how its inter-node locking and journal
recovery are coordinated. (I haven't tried it in recent years).

Regards,

Bob Peterson
Red Hat File Systems
