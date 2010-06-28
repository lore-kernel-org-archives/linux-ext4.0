From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] Ext4: Make file creation time, i_version and i_generation
	available by xattrs
Date: Mon, 28 Jun 2010 14:41:02 -0500
Message-ID: <AANLkTikhZn15GmOTe-fsM2IgxHFxtZIRBOb_4kPWSR4E@mail.gmail.com>
References: <20100628162626.6026.26679.stgit@warthog.procyon.org.uk>
	<19AAF9AA-2445-4C73-808B-4AD9C5C7E769@dilger.ca>
	<8831.1277753903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, viro@zeniv.linux.org.uk,
	jlayton@redhat.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44588 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab0F1TlD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jun 2010 15:41:03 -0400
In-Reply-To: <8831.1277753903@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 28, 2010 at 2:38 PM, David Howells <dhowells@redhat.com> wr=
ote:
> Andreas Dilger <adilger@dilger.ca> wrote:
>
>> - I'd prefer calling these "file.generation" and "file.version".
>> =A0 I don't think there is value in the "i_" prefix adds anything,
>> =A0 and it seems more like an internal detail to me
>
> That's reasonable.
>
>> - why not expose the ".version" field for regular files? =A0It seems
>> =A0 that all of them are applicable for all file types.
>
> Because Ext4 doesn't support it for anything other than directories.
>
>> - it would be good to not introduce a new xattr namespace, since
>> =A0 tools like tar (even the RHEL-patched one) will not backup and
>> =A0 restore these namespaces. =A0Using "trusted." would allow them t=
o
>> =A0 be backed up and restored using existing xattr-patched GNU tar
>> =A0 by root, but wouldn't allow them to be modified by regular users=
=2E
>> =A0 I think this is important for proper backup/restore of a filesys=
tem,
>> =A0 but can have correctness implications and shouldn't be accessibl=
e
>> =A0 to regular users.
>
> Does backing them up make sense, though? =A0They are filesystem struc=
tural
> attributes. =A0Can you restore the inode number, for example? =A0If n=
ot, then you
> can't restore i_generation either. =A0Restoring i_version might make =
sense, but
> what if it winds i_version backwards whilst maintaining i_ino and i_g=
eneration,
> that means there'll be a time in the future where the three values ar=
e once
> again what might have been already published - and may already be in =
someone's
> persistent cache.

I think backing them up makes sense, even if they can't easily
be restored (ie just for reporting).

Are there security differences between the "trusted" namespace that
would make it harder for an app to read them (the man page did not list
the security differences between trusted and user xattrs).


--=20
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
