From: Wang Shilong <wshilong@ddn.com>
Subject: RE: [PATCH v4] ext4: reduce lock contention in __ext4_new_inode
Date: Thu, 17 Aug 2017 06:23:26 +0000
Message-ID: <3ED34739A4E85E4F894367D57617CDEFEDA401CE@LAX-EX-MB2.datadirect.datadirectnet.com>
References: <20170808050517.7160-1-wshilong@ddn.com>,<20170816164211.GA31117@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="_002_3ED34739A4E85E4F894367D57617CDEFEDA401CELAXEXMB2datadir_"
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "adilger@dilger.ca" <adilger@dilger.ca>,
        Shuichi Ihara <sihara@ddn.com>, Li Xi <lixi@ddn.com>
To: Jan Kara <jack@suse.cz>, Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from legacy.ddn.com ([64.47.133.206]:54934 "EHLO legacy.ddn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750943AbdHQGX3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 17 Aug 2017 02:23:29 -0400
In-Reply-To: <20170816164211.GA31117@quack2.suse.cz>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--_002_3ED34739A4E85E4F894367D57617CDEFEDA401CELAXEXMB2datadir_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Jan,=0A=
=0A=
     thanks for good suggestion, just one question we could not hold lock=
=0A=
with nojounal mode, how about something attached one?=0A=
=0A=
please let me know if you have better taste for it, much appreciated!=0A=
=0A=
=0A=
Thanks,=0A=
Shilong=0A=
=0A=
=0A=
________________________________________=0A=
From: Jan Kara [jack@suse.cz]=0A=
Sent: Thursday, August 17, 2017 0:42=0A=
To: Wang Shilong=0A=
Cc: linux-ext4@vger.kernel.org; tytso@mit.edu; Wang Shilong; adilger@dilger=
.ca; Shuichi Ihara; Li Xi=0A=
Subject: Re: [PATCH v4] ext4: reduce lock contention in __ext4_new_inode=0A=
=0A=
On Tue 08-08-17 13:05:17, Wang Shilong wrote:=0A=
> From: Wang Shilong <wshilong@ddn.com>=0A=
>=0A=
> While running number of creating file threads concurrently,=0A=
> we found heavy lock contention on group spinlock:=0A=
>=0A=
> FUNC                           TOTAL_TIME(us)       COUNT        AVG(us)=
=0A=
> ext4_create                    1707443399           1440000      1185.72=
=0A=
> _raw_spin_lock                 1317641501           180899929    7.28=0A=
> jbd2__journal_start            287821030            1453950      197.96=
=0A=
> jbd2_journal_get_write_access  33441470             73077185     0.46=0A=
> ext4_add_nondir                29435963             1440000      20.44=0A=
> ext4_add_entry                 26015166             1440049      18.07=0A=
> ext4_dx_add_entry              25729337             1432814      17.96=0A=
> ext4_mark_inode_dirty          12302433             5774407      2.13=0A=
>=0A=
> most of cpu time blames to _raw_spin_lock, here is some testing=0A=
> numbers with/without patch.=0A=
>=0A=
> Test environment:=0A=
> Server : SuperMicro Sever (2 x E5-2690 v3@2.60GHz, 128GB 2133MHz=0A=
>          DDR4 Memory, 8GbFC)=0A=
> Storage : 2 x RAID1 (DDN SFA7700X, 4 x Toshiba PX02SMU020 200GB=0A=
>           Read Intensive SSD)=0A=
>=0A=
> format command:=0A=
>         mkfs.ext4 -J size=3D4096=0A=
>=0A=
> test command:=0A=
>         mpirun -np 48 mdtest -n 30000 -d /ext4/mdtest.out -F -C \=0A=
>                 -r -i 1 -v -p 10 -u #first run to load inode=0A=
>=0A=
>         mpirun -np 48 mdtest -n 30000 -d /ext4/mdtest.out -F -C \=0A=
>                 -r -i 5 -v -p 10 -u=0A=
>=0A=
> Kernel version: 4.13.0-rc3=0A=
>=0A=
> Test  1,440,000 files with 48 directories by 48 processes:=0A=
>=0A=
> Without patch:=0A=
>=0A=
> File Creation   File removal=0A=
> 79,033          289,569 ops/per second=0A=
> 81,463          285,359=0A=
> 79,875          288,475=0A=
> 79,917          284,624=0A=
> 79,420          290,91=0A=
>=0A=
> with patch:=0A=
> File Creation   File removal=0A=
> 691,528               296,574 ops/per second=0A=
> 691,946               297,106=0A=
> 692,030               296,238=0A=
> 691,005               299,249=0A=
> 692,871               300,664=0A=
>=0A=
> Creation performance is improved more than 8X with large=0A=
> journal size. The main problem here is we test bitmap=0A=
> and do some check and journal operations which could be=0A=
> slept, then we test and set with lock hold, this could=0A=
> be racy, and make 'inode' steal by other process.=0A=
>=0A=
> However, after first try, we could confirm handle has=0A=
> been started and inode bitmap journaled too, then=0A=
> we could find and set bit with lock hold directly, this=0A=
> will mostly gurateee success with second try.=0A=
>=0A=
> This patch dosen't change logic if it comes to=0A=
> no journal mode, luckily this is not normal=0A=
> use cases i believe.=0A=
>=0A=
> Tested-by: Shuichi Ihara <sihara@ddn.com>=0A=
> Signed-off-by: Wang Shilong <wshilong@ddn.com>=0A=
=0A=
The results look great and the code looks correct however I dislike the=0A=
somewhat complex codeflow with your hold_lock variable. So how about=0A=
cleaning up the code as follows:=0A=
=0A=
Create function like=0A=
=0A=
unsigned long find_inode_bit(struct super_block *sb, ext4_group_t group,=0A=
                struct buffer_head *bitmap, unsigned long start_ino)=0A=
{=0A=
        unsigned long ino;=0A=
=0A=
next:=0A=
        ino =3D ext4_find_next_zero_bit(...);=0A=
        if (ino >=3D EXT4_INODES_PER_GROUP(sb))=0A=
                return 0;=0A=
        if (group =3D=3D 0 && (ino+1) < EXT4_FIRST_INO(sb)) {=0A=
                ...=0A=
                return 0;=0A=
        }=0A=
        if ((EXT4_SB(sb)->s_journal =3D=3D NULL) &&=0A=
                    recently_deleted(sb, group, ino)) {=0A=
                start_ino =3D ino + 1;=0A=
                if (start_ino < EXT4_INODES_PER_GROUP(sb))=0A=
                        goto next;=0A=
        }=0A=
        return ino;=0A=
}=0A=
=0A=
Then you can use this function from __ext4_new_inode() when looking for=0A=
free ino and also in case test_and_set_bit() fails you could just do:=0A=
=0A=
ext4_lock_group(sb, group);=0A=
ret2 =3D ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data);=0A=
if (ret2) {=0A=
        /* Someone already took the bit. Repeat the search with lock held.*=
/=0A=
        ino =3D find_inode_bit(sb, group, inode_bitmap_bh, ino);=0A=
        if (ino) {=0A=
                ret2 =3D ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data=
);=0A=
                WARN_ON_ONCE(!ret2);=0A=
        }=0A=
}=0A=
ext4_unlock_group(sb, group);=0A=
=0A=
And that's it, no strange bool variables and conditional locking. And as a=
=0A=
bonus it also works for nojournal mode in the same way.=0A=
=0A=
                                                                Honza=0A=
=0A=
> ---=0A=
> v3->v4: codes cleanup and avoid sleep.=0A=
> ---=0A=
>  fs/ext4/ialloc.c | 30 +++++++++++++++++++++++++++++-=0A=
>  1 file changed, 29 insertions(+), 1 deletion(-)=0A=
>=0A=
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c=0A=
> index 507bfb3..23380f39 100644=0A=
> --- a/fs/ext4/ialloc.c=0A=
> +++ b/fs/ext4/ialloc.c=0A=
> @@ -761,6 +761,7 @@ struct inode *__ext4_new_inode(handle_t *handle, stru=
ct inode *dir,=0A=
>       ext4_group_t flex_group;=0A=
>       struct ext4_group_info *grp;=0A=
>       int encrypt =3D 0;=0A=
> +     bool hold_lock;=0A=
>=0A=
>       /* Cannot create files in a deleted directory */=0A=
>       if (!dir || !dir->i_nlink)=0A=
> @@ -917,17 +918,40 @@ struct inode *__ext4_new_inode(handle_t *handle, st=
ruct inode *dir,=0A=
>                       continue;=0A=
>               }=0A=
>=0A=
> +             hold_lock =3D false;=0A=
>  repeat_in_this_group:=0A=
> +             /* if @hold_lock is ture, that means, journal=0A=
> +              * is properly setup and inode bitmap buffer has=0A=
> +              * been journaled already, we can directly hold=0A=
> +              * lock and set bit if found, this will mostly=0A=
> +              * gurantee forward progress for each thread.=0A=
> +              */=0A=
> +             if (hold_lock)=0A=
> +                     ext4_lock_group(sb, group);=0A=
> +=0A=
>               ino =3D ext4_find_next_zero_bit((unsigned long *)=0A=
>                                             inode_bitmap_bh->b_data,=0A=
>                                             EXT4_INODES_PER_GROUP(sb), in=
o);=0A=
> -             if (ino >=3D EXT4_INODES_PER_GROUP(sb))=0A=
> +             if (ino >=3D EXT4_INODES_PER_GROUP(sb)) {=0A=
> +                     if (hold_lock)=0A=
> +                             ext4_unlock_group(sb, group);=0A=
>                       goto next_group;=0A=
> +             }=0A=
>               if (group =3D=3D 0 && (ino+1) < EXT4_FIRST_INO(sb)) {=0A=
> +                     if (hold_lock)=0A=
> +                             ext4_unlock_group(sb, group);=0A=
>                       ext4_error(sb, "reserved inode found cleared - "=0A=
>                                  "inode=3D%lu", ino + 1);=0A=
>                       continue;=0A=
>               }=0A=
> +=0A=
> +             if (hold_lock) {=0A=
> +                     ext4_set_bit(ino, inode_bitmap_bh->b_data);=0A=
> +                     ext4_unlock_group(sb, group);=0A=
> +                     ino++;=0A=
> +                     goto got;=0A=
> +             }=0A=
> +=0A=
>               if ((EXT4_SB(sb)->s_journal =3D=3D NULL) &&=0A=
>                   recently_deleted(sb, group, ino)) {=0A=
>                       ino++;=0A=
> @@ -950,6 +974,10 @@ struct inode *__ext4_new_inode(handle_t *handle, str=
uct inode *dir,=0A=
>                       ext4_std_error(sb, err);=0A=
>                       goto out;=0A=
>               }=0A=
> +=0A=
> +             if (EXT4_SB(sb)->s_journal)=0A=
> +                     hold_lock =3D true;=0A=
> +=0A=
>               ext4_lock_group(sb, group);=0A=
>               ret2 =3D ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data=
);=0A=
>               ext4_unlock_group(sb, group);=0A=
> --=0A=
> 2.9.3=0A=
>=0A=
--=0A=
Jan Kara <jack@suse.com>=0A=
SUSE Labs, CR=0A=

--_002_3ED34739A4E85E4F894367D57617CDEFEDA401CELAXEXMB2datadir_
Content-Type: application/octet-stream; name="modfied.patch"
Content-Description: modfied.patch
Content-Disposition: attachment; filename="modfied.patch"; size=3156;
	creation-date="Thu, 17 Aug 2017 06:22:27 GMT";
	modification-date="Thu, 17 Aug 2017 06:22:27 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2ZzL2V4dDQvaWFsbG9jLmMgYi9mcy9leHQ0L2lhbGxvYy5jCmluZGV4IDBh
OWI0OGYuLmEzOTEyY2YgMTAwNjQ0Ci0tLSBhL2ZzL2V4dDQvaWFsbG9jLmMKKysrIGIvZnMvZXh0
NC9pYWxsb2MuYwpAQCAtNzMwLDYgKzczMCwzOSBAQCBzdGF0aWMgaW50IHJlY2VudGx5X2RlbGV0
ZWQoc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwgZXh0NF9ncm91cF90IGdyb3VwLCBpbnQgaW5vKQog
CXJldHVybiByZXQ7CiB9CiAKK3N0YXRpYyB1bnNpZ25lZCBsb25nIGZpbmRfaW5vZGVfYml0KHN0
cnVjdCBzdXBlcl9ibG9jayAqc2IsCisJCQkJICAgIGV4dDRfZ3JvdXBfdCBncm91cCwKKwkJCQkg
ICAgc3RydWN0IGJ1ZmZlcl9oZWFkICpiaXRtYXAsCisJCQkJICAgIHVuc2lnbmVkIGxvbmcgaW5v
LCBib29sIGdycF9sb2NrZWQpCit7CituZXh0OgorCWlubyA9IGV4dDRfZmluZF9uZXh0X3plcm9f
Yml0KCh1bnNpZ25lZCBsb25nICopCisJCQkJICAgICAgYml0bWFwLT5iX2RhdGEsCisJCQkJICAg
ICAgRVhUNF9JTk9ERVNfUEVSX0dST1VQKHNiKSwgaW5vKTsKKwlpZiAoaW5vID49IEVYVDRfSU5P
REVTX1BFUl9HUk9VUChzYikpCisJCXJldHVybiAwOworCisJaWYgKGdyb3VwID09IDAgJiYgKGlu
byArIDEpIDwgRVhUNF9GSVJTVF9JTk8oc2IpKSB7CisJCWlmIChncnBfbG9ja2VkKQorCQkJZXh0
NF91bmxvY2tfZ3JvdXAoc2IsIGdyb3VwKTsKKwkJZXh0NF9lcnJvcihzYiwgInJlc2VydmVkIGlu
b2RlIGZvdW5kIGNsZWFyZWQgLSAiCisJCQkgICAgICAgImlub2RlPSVsdSIsIGlubyArIDEpOwor
CQlpZiAoZ3JwX2xvY2tlZCkKKwkJCWV4dDRfbG9ja19ncm91cChzYiwgZ3JvdXApOworCQlyZXR1
cm4gMDsKKwl9CisKKwlpZiAoKEVYVDRfU0Ioc2IpLT5zX2pvdXJuYWwgPT0gTlVMTCkgJiYKKwkg
ICAgcmVjZW50bHlfZGVsZXRlZChzYiwgZ3JvdXAsIGlubykpIHsKKwkJaW5vKys7CisJCWlmIChp
bm8gPCBFWFQ0X0lOT0RFU19QRVJfR1JPVVAoc2IpKQorCQkJZ290byBuZXh0OworCQlyZXR1cm4g
MDsKKwl9CisKKwlyZXR1cm4gaW5vOworfQorCiAvKgogICogVGhlcmUgYXJlIHR3byBwb2xpY2ll
cyBmb3IgYWxsb2NhdGluZyBhbiBpbm9kZS4gIElmIHRoZSBuZXcgaW5vZGUgaXMKICAqIGEgZGly
ZWN0b3J5LCB0aGVuIGEgZm9yd2FyZCBzZWFyY2ggaXMgbWFkZSBmb3IgYSBibG9jayBncm91cCB3
aXRoIGJvdGgKQEAgLTkxMCwyMSArOTQzLDExIEBAIHN0cnVjdCBpbm9kZSAqX19leHQ0X25ld19p
bm9kZShoYW5kbGVfdCAqaGFuZGxlLCBzdHJ1Y3QgaW5vZGUgKmRpciwKIAkJfQogCiByZXBlYXRf
aW5fdGhpc19ncm91cDoKLQkJaW5vID0gZXh0NF9maW5kX25leHRfemVyb19iaXQoKHVuc2lnbmVk
IGxvbmcgKikKLQkJCQkJICAgICAgaW5vZGVfYml0bWFwX2JoLT5iX2RhdGEsCi0JCQkJCSAgICAg
IEVYVDRfSU5PREVTX1BFUl9HUk9VUChzYiksIGlubyk7Ci0JCWlmIChpbm8gPj0gRVhUNF9JTk9E
RVNfUEVSX0dST1VQKHNiKSkKLQkJCWdvdG8gbmV4dF9ncm91cDsKLQkJaWYgKGdyb3VwID09IDAg
JiYgKGlubysxKSA8IEVYVDRfRklSU1RfSU5PKHNiKSkgewotCQkJZXh0NF9lcnJvcihzYiwgInJl
c2VydmVkIGlub2RlIGZvdW5kIGNsZWFyZWQgLSAiCi0JCQkJICAgImlub2RlPSVsdSIsIGlubyAr
IDEpOworCQlpbm8gPSBmaW5kX2lub2RlX2JpdChzYiwgZ3JvdXAsIGlub2RlX2JpdG1hcF9iaCwK
KwkJCQkgICAgIGlubywgZmFsc2UpOworCQlpZiAoIWlubykKIAkJCWdvdG8gbmV4dF9ncm91cDsK
LQkJfQotCQlpZiAoKEVYVDRfU0Ioc2IpLT5zX2pvdXJuYWwgPT0gTlVMTCkgJiYKLQkJICAgIHJl
Y2VudGx5X2RlbGV0ZWQoc2IsIGdyb3VwLCBpbm8pKSB7Ci0JCQlpbm8rKzsKLQkJCWdvdG8gbmV4
dF9pbm9kZTsKLQkJfQorCiAJCWlmICghaGFuZGxlKSB7CiAJCQlCVUdfT04obmJsb2NrcyA8PSAw
KTsKIAkJCWhhbmRsZSA9IF9fZXh0NF9qb3VybmFsX3N0YXJ0X3NiKGRpci0+aV9zYiwgbGluZV9u
bywKQEAgLTkzNiwxOSArOTU5LDM3IEBAIHN0cnVjdCBpbm9kZSAqX19leHQ0X25ld19pbm9kZSho
YW5kbGVfdCAqaGFuZGxlLCBzdHJ1Y3QgaW5vZGUgKmRpciwKIAkJCQlnb3RvIG91dDsKIAkJCX0K
IAkJfQorCiAJCUJVRkZFUl9UUkFDRShpbm9kZV9iaXRtYXBfYmgsICJnZXRfd3JpdGVfYWNjZXNz
Iik7CiAJCWVyciA9IGV4dDRfam91cm5hbF9nZXRfd3JpdGVfYWNjZXNzKGhhbmRsZSwgaW5vZGVf
Yml0bWFwX2JoKTsKIAkJaWYgKGVycikgewogCQkJZXh0NF9zdGRfZXJyb3Ioc2IsIGVycik7CiAJ
CQlnb3RvIG91dDsKIAkJfQorCiAJCWV4dDRfbG9ja19ncm91cChzYiwgZ3JvdXApOwogCQlyZXQy
ID0gZXh0NF90ZXN0X2FuZF9zZXRfYml0KGlubywgaW5vZGVfYml0bWFwX2JoLT5iX2RhdGEpOwor
CQlpZiAocmV0MiAmJiBFWFQ0X1NCKHNiKS0+c19qb3VybmFsID09IE5VTEwpIHsKKwkJCS8qIFNv
bWVvbmUgYWxyZWFkeSB0b29rIHRoZSBiaXQuIFJlcGVhdCB0aGUgc2VhcmNoCisJCQkgKiB3aXRo
IGxvY2sgaGVsZCwgZnVuY3Rpb24gbWlnaHQgc2xlZXAgaW4gdHdvIGNhc2VzOgorCQkJICogMSkg
bm8gam91cm5hbCBtb2RlLgorCQkJICogMikgam91cm5hbCBtb2RlIGJ1dCBoaXQgbG9naWMgZXJy
b3IuCisJCQkgKiBvbmx5IGhvbGQgbG9jayBpbiBqb3VybmFsIG1vZGUsIGJ1dCBzdGlsbCBuZWVk
CisJCQkgKiB0YWtlIGNhcmUgb2YgZXJyb3IgY2FzZS4KKwkJCSAqLworCQkJaW5vID0gZmluZF9p
bm9kZV9iaXQoc2IsIGdyb3VwLCBpbm9kZV9iaXRtYXBfYmgsCisJCQkJCSAgICAgaW5vLCB0cnVl
KTsKKwkJCWlmIChpbm8pIHsKKwkJCQlyZXQyID0gZXh0NF90ZXN0X2FuZF9zZXRfYml0KGlubywK
KwkJCQkJCWlub2RlX2JpdG1hcF9iaC0+Yl9kYXRhKTsKKwkJCQlXQVJOX09OX09OQ0UoIXJldDIp
OworCQkJfQorCQl9CiAJCWV4dDRfdW5sb2NrX2dyb3VwKHNiLCBncm91cCk7CiAJCWlubysrOwkJ
LyogdGhlIGlub2RlIGJpdG1hcCBpcyB6ZXJvLWJhc2VkICovCiAJCWlmICghcmV0MikKIAkJCWdv
dG8gZ290OyAvKiB3ZSBncmFiYmVkIHRoZSBpbm9kZSEgKi8KLW5leHRfaW5vZGU6CisKIAkJaWYg
KGlubyA8IEVYVDRfSU5PREVTX1BFUl9HUk9VUChzYikpCiAJCQlnb3RvIHJlcGVhdF9pbl90aGlz
X2dyb3VwOwogbmV4dF9ncm91cDoK

--_002_3ED34739A4E85E4F894367D57617CDEFEDA401CELAXEXMB2datadir_--
