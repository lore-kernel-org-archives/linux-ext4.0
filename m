From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [BUG] ext3: cannot unfreeze a filesystem due to a deadlock
Date: Wed, 7 Sep 2011 12:45:34 -0400
Message-ID: <CAGpXXZL=+K0ETvM0kGE6zqe3pB7AS_exU+dCbpm+uUSG2JJ+0A@mail.gmail.com>
References: <20110907122929.3715.61FB500B@jp.fujitsu.com> <20110907064006.GA16042@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110907064006.GA16042@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 7, 2011 at 2:40 AM, Christoph Hellwig <hch@infradead.org> w=
rote:
> On Wed, Sep 07, 2011 at 12:29:30PM +0900, Masayoshi MIZUMA wrote:
>> Hi,
>>
>> When I checked the freeze feature for ext3 filesystem using fsfreeze
>> command at 3.1.0-rc4, I think the following deadlock problem happene=
d.
>>
>> How to reproduce:
>> =A0# mkfs -t ext3 /dev/sdd1
>> =A0# mount /dev/sdd1 /MNT
>> =A0# ./fsstress -d /MNT/tmp -n 10 -p 1000 > /dev/null 2>&1 &
>> =A0# fsfreeze -f /MNT
>> =A0# fsfreeze -u /MNT
>
> Can you add this testcase to xfstests?

Christoph,

Isn't that just a matter of extending test 068 to ext4

=3D=3D=3D=3D
--- 068 2011-06-30 18:41:17.000000000 -0400
+++ 068.new     2011-09-07 12:41:35.000000000 -0400
@@ -51,7 +51,7 @@
 . ./common.filter

 # real QA test starts here
-_supported_fs xfs
+_supported_fs xfs ext3 ext4
 _supported_os Linux IRIX

 _require_scratch
=3D=3D=3D=3D

That's a totally untested patch if someone wants to try it.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
