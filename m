From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH RFC] add FIEMAP_FLAG_DISCARD support
Date: Mon, 4 Nov 2013 17:35:30 -0700
Message-ID: <16F3FABA-72ED-47C2-95E9-974262F95F07@dilger.ca>
References: <1383435930-29295-1-git-send-email-tytso@mit.edu> <20131103231442.GM6188@dastard> <20131103234200.GE7376@thunk.org> <20131104215736.GR6188@dastard>
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1816\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>,
	"linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20131104215736.GR6188@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 4, 2013, at 2:57 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Nov 03, 2013 at 06:42:00PM -0500, Theodore Ts'o wrote:
>> On Mon, Nov 04, 2013 at 10:14:42AM +1100, Dave Chinner wrote:
>>>=20
>>> FIEMAP is not the correct interface for data modifying operations.
>>> It is an interface that returns information about file metadata (i.=
e
>>> the layout of a file) - it is not an interface for modifying the
>>> contents of the file.
>>=20
>> Well, it's been argued that FIEMAP was designed to be extensible, an=
d
>> we should use it for other operations.  Where the bounds of that
>> stretches to is certainly an arguable point, and I can understand yo=
ur
>> observation that something which causes a change to the contents of
>> the file might not be best choice.
>=20
> Yes, I agree it is extensible, but it was never intended to be
> extended into a data modification ioctl. It's for querying metadata
> related to file data, not for modifying file data.

I=92d agree with Dave here - there is nothing about FIEMAP that indicat=
es
it is an interface for data modification, only for reporting out the
underlying layout of a file.  I think falloc() is already used in this
regard for hole punching, and it makes more sense to me to extend that
for the discard interface as well.

Cheers, Andreas





--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
