From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended file stats available [ver #6]
Date: Sat, 31 Jul 2010 12:41:41 -0600
Message-ID: <09B770A6-48DB-4296-B6C2-BF46D4DC7E57@dilger.ca>
References: <20100715021712.5544.44845.stgit@warthog.procyon.org.uk> <30448.1279800887@redhat.com> <E1Obuiy-00C9jr-Al@intern.SerNet.DE> <AANLkTikBCXK6uEwWq4f0LvpdoKCPs3jvyFa4Zw4e2J_7@mail.gmail.com> <E1Obxpd-00CRIo-SF@intern.SerNet.DE> <AANLkTimwIq0pBhCeOjOVjB0yeM3JHOvzVoj9M4ui6al9@mail.gmail.com> <20100722162712.GB10352@jeremy-laptop> <AANLkTimdFCGSKLn7aGMpBMIauHTsHY7hpAAmpo6uTcnD@mail.gmail.com> <1279817930.3621.14.camel@heimdal.trondhjem.org> <20100722180204.GA32008@samba1> <E1Oc08W-00CZuz-Ns@intern.SerNet.DE> <1279825160.3621.71.camel@heimdal.trondhjem.org> <4C5311F4.2050100@psu.edu> <1280513506.12852.22.camel@heimdal.trondhjem.org>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Phil Pishioneri <pgp-8DAjSxpRXgY@public.gmane.org>, Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <trond.myklebust-41N18TsMXrtuMpJDpNschA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280513506.12852.22.camel-rJ7iovZKK19ZJLDQqaL3InhyD016LWXt@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 2010-07-30, at 12:11, Trond Myklebust wrote:
> Your Mac has a perfectly functional CIFS client, as do your Linux boxes.
> They both interoperate just fine with Samba, and would presumably
> continue to do so if someone were to decide to reuse the ctime field on
> your Samba box as storage for a create time.

CIFS doesn't support symlinks (they just appear as the referenced file), so I've had applications that scan the filesystem recurse indefinitely due to symlinked directories on a CIFS share appearing as hard-linked directories on the client.  This doesn't happen when the filesystem is accessed via NFS.

Cheers, Andreas
