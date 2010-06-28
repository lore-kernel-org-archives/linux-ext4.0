From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] Ext4: Make file creation time, i_version and i_generation
	available by xattrs
Date: Mon, 28 Jun 2010 12:04:09 -0500
Message-ID: <AANLkTilkfPkvyuQvN9zKrrY3DhJZ5iUfa5RXfErFwTiA@mail.gmail.com>
References: <20100628162626.6026.26679.stgit@warthog.procyon.org.uk>
	<AANLkTikkaRYyUfHILDCKYzXdLi9ORuQs05Rf9TScF_Tz@mail.gmail.com>
	<20100628164854.GA9979@samba1>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk,
	jlayton@redhat.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: Jeremy Allison <jra@samba.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100628164854.GA9979@samba1>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 28, 2010 at 11:48 AM, Jeremy Allison <jra@samba.org> wrote:
> On Mon, Jun 28, 2010 at 11:33:10AM -0500, Steve French wrote:
>>
>> It would be easy enough to do something similar for crtime for cifs
>> (it may also be possible to do something similar to
>> i_generation and i_version at least for smb2 but haven't
>> experimented to see which servers could return something
>> similar to version and generation). =A0I did have a request for
>> someone doing a backup application over cifs to return creation
>> time so at least this would make sense.
>
> We already have code in Samba to detect "birthtime"
> (st_btime) as a returned member of a stat struct.
>
> This already works on many other platforms, so I'd
> rather just have Linux stat fixed to work with
> btime.

That sounds better but it hits the fs, vfs and libc
and seems like libc is near impossible to get changes into.
Seems like in the short term adding xattrs is harmless, and
doesn't hurt in the longrun


--=20
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
